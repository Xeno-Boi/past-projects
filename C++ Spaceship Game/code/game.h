#ifndef GAME_H_
#define GAME_H_

#define GLEW_STATIC
#include <GL/glew.h>
#include <GLFW/glfw3.h>

#include "config.h"

#include "shader.h"
#include "sprite.h"
#include "background_sprite.h"
#include "game_object.h"
#include "player_game_object.h"
#include "background_controller_object.h"

namespace game {

    // A class for holding the main game objects
    class Game {

        public:
            // Constructor and destructor
            Game(void);
            ~Game();

            // Call Init() before calling any other method
            // Initialize graphics libraries and main window
            void Init(void); 

            // Set up the game (scene, game objects, etc.)
            void Setup(void);

            // Run the game (keep the game active)
            void MainLoop(void); 

        private:
            // Main window: pointer to the GLFW window structure
            GLFWwindow *window_;

            // Sprite geometry
            Geometry *sprite_;

            // Background Sprite
            Geometry* background_sprite_;

            // Particle geometry
            Geometry *particles_;

            // Shader for rendering sprites in the scene
            Shader sprite_shader_;

            // Shader for rendering particles
            Shader particle_shader_;


            // Textures
            
            // main
            GLuint* tex_;

            // Groups
            // Player
            GLuint player_body_tex_;
            
            // Background
            GLuint* background_tex_;


            // GameObjects

            // main
            std::vector <std::vector<GameObject*>*> game_objects_;

            // Groups
            
            // Player
            std::vector <GameObject*> player_objects_;
            // Player body
            PlayerGameObject* player;

            // Enemies
            std::vector <GameObject*> enemy_objects_;

            // Background
            std::vector <GameObject*> background_objects_;


            // Keep track of time
            double current_time_;

            // Game State
            int state_;

            // Callback for when the window is resized
            static void ResizeCallback(GLFWwindow* window, int width, int height);

            // Set a specific texture
            void SetTexture(GLuint w, const char *fname);

            // Load all textures
            void SetAllTextures();

            // Handle user input for different game state
            void HandleControlsInGame(double delta_time);

            void HandleControlsEndScreen(double delta_time);

            // Update all the game objects
            void Update(double delta_time);
 
            // Render the game world
            void Render(void);

    }; // class Game

} // namespace game

#endif // GAME_H_
