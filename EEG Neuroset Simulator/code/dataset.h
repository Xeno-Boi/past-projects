#ifndef DATASET_H
#define DATASET_H

#include <vector>
#include "config.h"

using namespace std;

// all amplitudes 10
// all frequencies 5
// pre baseline = 5
class Dataset {
public:
    Dataset(){};

    static void initDataset();

    // getters
    static vector<SensorData> getDataset1();
    static vector<SensorData> getDataset2();
    static vector<SensorData> getDatasetAlpha();
    static vector<SensorData> getDatasetBeta();
    static vector<SensorData> getDatasetDelta();
    static vector<SensorData> getDatasetTheta();
    static vector<SensorData> getDatasetGamma();

private:
    static vector<SensorData> dataset1;
    static vector<SensorData> dataset2;
    static vector<SensorData> dataset_alpha;
    static vector<SensorData> dataset_beta;
    static vector<SensorData> dataset_delta;
    static vector<SensorData> dataset_theta;
    static vector<SensorData> dataset_gamma;
};

#endif // DATASET_H
