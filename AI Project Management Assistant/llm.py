'''
LLM Functions for the LangGraph Assignment application
Handles requests and interactions with the LangGraph framework.
'''

# imports

from defs import *
from helpers import *
from tools import tool_list, run_tool
from prompt import PROMPT
from state import projects

from typing import TypedDict, Annotated

from langchain_ollama import ChatOllama
from langgraph.graph import (
    StateGraph,
    START,
    END,
    add_messages,
)
from langgraph.graph.state import CompiledStateGraph

from langchain_core.messages import (
    BaseMessage,
    HumanMessage,
    AIMessage,
    SystemMessage,
    ToolMessage,
)


# State for LangGraph --------------------------------------------------
class GraphState(TypedDict):
    messages: Annotated[list[BaseMessage], add_messages]    # List of messages in the conversation context
    reply: AIMessage | None    # The latest reply from the AI
    

# LLM ------------------------------------------------------------------

# create the LLM object
llm = ChatOllama(
    model = MODEL_NAME,
    temperature=0
).bind_tools(tool_list)


def llm_request(messages: list[BaseMessage]):
    '''
    Sends a list of messages to the LLM and returns the AI's response.

    Args:
        messages (list[BaseMessage]): A list of HumanMessage and AIMessage objects representing the conversation history.

    Returns:
        AIMessage: The AI's response message.
    '''
    return llm.invoke(
            [SystemMessage(content = f'''
                            {PROMPT}
                            
                            Here is the CURRENT PROJECT LIST:
                            {projects}
                            ''')] +
            messages[-MESSAGE_SIZE:]
        )
    

# Nodes -----------------------------------------------------------------

def llm_response_node(state: GraphState):
    '''
    Processes the current state and generates a response from the LLM.
    '''
    messages = state["messages"]
    
    if DEBUG:
        print("Current state message:", state["messages"])
    
    response = llm_request(messages)
    
    output_state = {}
    output_state["messages"] = [response]   # add_messages automatially appends to messages
    output_state["reply"] = response
    
    return output_state


def tool_call_node(state: GraphState):
    '''
    Performs all tool calls based on the current state.
    Generates ToolMessage objects based on the current state.
    '''
    tool_call_list: list[dict] = state["reply"].tool_calls
    output_tool_messages: list[ToolMessage] = []
        
    if DEBUG:
        print("Current tool calls:", tool_call_list)
    
    for tool_call in tool_call_list:
        try:
            tool_message = run_tool(tool_call)

            if DEBUG:
                print(f"Tool call result: {tool_message}")
                
            output_tool_messages.append(tool_message)
            
        except Exception as e:
            if DEBUG:
                print(f"Error processing tool call {tool_call['name']}: {e}")
            output_tool_messages.append(
                ToolMessage(
                    content=f"Tool execution failed: {e}",
                    tool_call_id=tool_call["id"]
                )
            )

    output_state = {}
    output_state["messages"] = output_tool_messages
    output_state["reply"] = None

    return output_state


# Conditional Router ----------------------------------------------------

def route_after_llm(state: GraphState):
    """
    Decide what happens after the LLM response node.

    If the LLM requested tools:
        "tools":go to tool_node

    Otherwise:
        end the graph
    """

    last_message = state["reply"]

    try:
        if last_message.tool_calls:
            return "tools"
    except AttributeError:
        pass

    return "end"


# Build Graph ------------------------------------------------------------

def build_graph() -> CompiledStateGraph:
    builder = StateGraph(GraphState)
    
    # add nodes
    builder.add_node("llm_response", llm_response_node)
    builder.add_node("tool_call", tool_call_node)
    
    # add edges
    builder.add_edge(START, "llm_response")
    builder.add_conditional_edges(
        "llm_response",
        route_after_llm,
        {
            "tools": "tool_call",
            "end": END,
        }
    )
    builder.add_edge("tool_call", "llm_response")

    # Compile and return graph
    graph = builder.compile()
    return graph


# Main Loop for Chatbot Interaction ---------------------------------------

def mainloop():
    '''
    main loop for the
    includes context management
    '''
    print("Hello! What would you like to do with your projects? type 'exit' to quit or 'print all' to display all projects.")
    
    # initialize the message history
    messages = []
    
    # compile state graph
    graph = build_graph()
    
    while True:
        user_input = input("\nYou: ")
        if user_input.lower() == "exit":
            print("Goodbye!")
            break
        if user_input.lower() == "print all":
            print_all_projects()
            continue
        
        # Add user input to the message context
        messages.append(HumanMessage(content=user_input))
        
        try:
            response_content: dict = graph.invoke({
                "messages": messages,
                "reply": None
            })
            
            # fetch new message history from request
            messages = response_content["messages"]
            
            # fetch ai reply
            reply = response_content["reply"]
            
            # print latest AI message
            print(f"\nBot: {reply.content}")
                
        except Exception as e:
            print(f"Error: {e}")
            print("Please try again.")
