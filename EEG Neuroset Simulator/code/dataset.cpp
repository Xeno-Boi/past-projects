#include "dataset.h"

using namespace std;

vector<SensorData> Dataset::dataset1;
vector<SensorData> Dataset::dataset2;
vector<SensorData> Dataset::dataset_alpha;
vector<SensorData> Dataset::dataset_beta;
vector<SensorData> Dataset::dataset_delta;
vector<SensorData> Dataset::dataset_theta;
vector<SensorData> Dataset::dataset_gamma;

void Dataset::initDataset(){
    // dataset 1
    for (int i = 0; i < 21; i++){
        dataset1.push_back(SensorData(10, 10, 10, 5, 5, 5));
    }

    // dataset 2
    dataset2.push_back(SensorData(4.2, 4.7, 1.0, 0.9, 2.3, 2.9));
    dataset2.push_back(SensorData(9.0, 9.7, 3.1, 5.9, 3.0, 9.2));
    dataset2.push_back(SensorData(0.1, 9.6, 4.0, 5.0, 8.7, 5.6));
    dataset2.push_back(SensorData(9.3, 9.5, 5.4, 2.9, 7.1, 6.6));
    dataset2.push_back(SensorData(6.0, 7.9, 1.9, 2.8, 3.2, 5.7));
    dataset2.push_back(SensorData(7.0, 4.9, 9.6, 5.8, 2.5, 1.3));
    dataset2.push_back(SensorData(6.5, 4.0, 8.5, 2.3, 8.9, 9.2));
    dataset2.push_back(SensorData(7.9, 5.5, 2.3, 3.3, 3.6, 5.7));
    dataset2.push_back(SensorData(2.5, 4.1, 6.9, 0.1, 6.3, 0.4));
    dataset2.push_back(SensorData(6.7, 3.6, 9.6, 7.8, 7.4, 0.2));
    dataset2.push_back(SensorData(8.0, 5.2, 4.4, 8.7, 9.0, 3.1));
    dataset2.push_back(SensorData(3.3, 0.4, 1.7, 7.5, 1.4, 1.7));
    dataset2.push_back(SensorData(4.2, 9.6, 9.2, 3.0, 5.6, 1.6));
    dataset2.push_back(SensorData(0.7, 6.2, 1.3, 0.8, 2.2, 0.1));
    dataset2.push_back(SensorData(4.4, 5.0, 3.6, 8.7, 4.1, 3.4));
    dataset2.push_back(SensorData(3.2, 5.5, 4.9, 4.4, 4.3, 3.4));
    dataset2.push_back(SensorData(1.6, 2.8, 4.8, 9.6, 0.8, 2.0));
    dataset2.push_back(SensorData(5.3, 0.1, 0.9, 2.9, 1.7, 9.7));
    dataset2.push_back(SensorData(7.0, 4.8, 4.3, 7.0, 2.6, 7.4));
    dataset2.push_back(SensorData(6.3, 1.9, 9.5, 3.8, 8.5, 9.9));
    dataset2.push_back(SensorData(9.9, 0.5, 9.0, 1.6, 4.0, 6.5));

    // dataset alpha
    dataset_alpha.push_back(SensorData(2.5, 10.4, 13.8, 8.1, 10.5, 11.7));
    dataset_alpha.push_back(SensorData(15.6, 7.7, 4.2, 11.2, 9.8, 8.4));
    dataset_alpha.push_back(SensorData(11.9, 19.2, 8.7, 10.1, 9.4, 12.0));
    dataset_alpha.push_back(SensorData(3.4, 1.1, 19.9, 9.9, 8.2, 8.9));
    dataset_alpha.push_back(SensorData(16.3, 13.1, 11.0, 8.0, 10.3, 11.1));
    dataset_alpha.push_back(SensorData(18.8, 6.0, 7.4, 11.5, 9.1, 8.7));
    dataset_alpha.push_back(SensorData(19.7, 4.8, 9.2, 10.6, 11.3, 8.5));
    dataset_alpha.push_back(SensorData(14.5, 3.3, 12.4, 9.0, 10.9, 9.6));
    dataset_alpha.push_back(SensorData(12.2, 16.7, 7.1, 11.9, 10.2, 8.8));
    dataset_alpha.push_back(SensorData(1.9, 19.5, 11.6, 11.1, 8.6, 9.5));
    dataset_alpha.push_back(SensorData(17.3, 8.4, 14.2, 10.5, 12.0, 11.0));
    dataset_alpha.push_back(SensorData(9.3, 11.6, 5.7, 8.8, 10.1, 9.9));
    dataset_alpha.push_back(SensorData(4.7, 18.1, 15.2, 9.2, 11.7, 8.3));
    dataset_alpha.push_back(SensorData(7.1, 10.2, 13.5, 11.4, 8.7, 12.0));
    dataset_alpha.push_back(SensorData(6.6, 2.4, 14.0, 10.0, 10.6, 11.8));
    dataset_alpha.push_back(SensorData(8.1, 20.0, 3.9, 11.8, 8.5, 9.3));
    dataset_alpha.push_back(SensorData(1.6, 15.7, 11.3, 10.7, 8.4, 9.7));
    dataset_alpha.push_back(SensorData(14.0, 2.9, 7.6, 11.2, 10.2, 8.1));
    dataset_alpha.push_back(SensorData(17.9, 18.6, 9.5, 9.6, 8.9, 11.3));
    dataset_alpha.push_back(SensorData(3.2, 11.4, 12.0, 8.3, 9.8, 10.4));
    dataset_alpha.push_back(SensorData(10.7, 6.9, 4.4, 11.6, 10.4, 8.2));


    // dataset beta
    dataset_beta.push_back(SensorData(5.6, 19.8, 3.4, 14.3, 22.7, 28.1));
    dataset_beta.push_back(SensorData(14.2, 11.0, 6.9, 15.6, 24.5, 29.9));
    dataset_beta.push_back(SensorData(17.8, 7.3, 9.4, 12.2, 16.8, 27.2));
    dataset_beta.push_back(SensorData(2.1, 18.6, 14.5, 19.3, 21.0, 30.0));
    dataset_beta.push_back(SensorData(10.7, 4.2, 16.9, 20.4, 23.6, 25.3));
    dataset_beta.push_back(SensorData(8.9, 12.5, 1.2, 16.1, 29.2, 12.3));
    dataset_beta.push_back(SensorData(3.5, 15.7, 11.9, 27.6, 12.7, 29.5));
    dataset_beta.push_back(SensorData(19.4, 2.3, 18.0, 24.4, 18.9, 14.8));
    dataset_beta.push_back(SensorData(7.2, 9.6, 20.0, 22.5, 25.1, 28.9));
    dataset_beta.push_back(SensorData(13.1, 16.4, 10.8, 26.8, 12.4, 17.5));
    dataset_beta.push_back(SensorData(1.5, 14.7, 6.3, 21.9, 19.6, 26.2));
    dataset_beta.push_back(SensorData(18.9, 6.1, 15.2, 29.3, 23.4, 20.7));
    dataset_beta.push_back(SensorData(12.8, 3.8, 17.6, 28.4, 14.2, 16.9));
    dataset_beta.push_back(SensorData(9.0, 20.0, 8.1, 15.0, 27.8, 23.9));
    dataset_beta.push_back(SensorData(16.2, 10.5, 13.7, 17.4, 20.6, 24.1));
    dataset_beta.push_back(SensorData(4.4, 7.8, 19.9, 14.7, 28.0, 12.6));
    dataset_beta.push_back(SensorData(15.3, 1.9, 5.8, 23.7, 21.1, 29.0));
    dataset_beta.push_back(SensorData(6.7, 13.2, 12.3, 18.9, 30.0, 27.4));
    dataset_beta.push_back(SensorData(11.4, 8.4, 2.0, 20.2, 14.8, 22.3));
    dataset_beta.push_back(SensorData(20.0, 17.5, 14.3, 24.9, 16.5, 12.8));
    dataset_beta.push_back(SensorData(2.7, 19.2, 10.6, 12.1, 17.9, 25.6));


    // dataset delta
    dataset_delta.push_back(SensorData(16.1, 14.7, 10.8, 2.3, 3.1, 1.9));
    dataset_delta.push_back(SensorData(7.2, 11.3, 5.8, 3.9, 1.4, 3.7));
    dataset_delta.push_back(SensorData(13.6, 3.7, 18.4, 1.2, 3.6, 2.8));
    dataset_delta.push_back(SensorData(10.5, 19.1, 6.9, 3.5, 1.9, 2.4));
    dataset_delta.push_back(SensorData(2.7, 8.9, 14.2, 3.2, 3.8, 1.2));
    dataset_delta.push_back(SensorData(9.8, 15.3, 12.7, 1.1, 3.0, 2.5));
    dataset_delta.push_back(SensorData(1.0, 16.2, 4.5, 2.4, 1.6, 3.9));
    dataset_delta.push_back(SensorData(11.7, 13.4, 8.6, 3.7, 2.1, 3.4));
    dataset_delta.push_back(SensorData(19.9, 17.0, 6.3, 1.3, 3.2, 2.9));
    dataset_delta.push_back(SensorData(15.4, 9.5, 12.2, 2.8, 1.5, 1.4));
    dataset_delta.push_back(SensorData(4.3, 6.7, 3.6, 1.0, 3.3, 3.1));
    dataset_delta.push_back(SensorData(18.1, 20.0, 7.2, 3.4, 2.6, 1.8));
    dataset_delta.push_back(SensorData(12.9, 10.1, 15.8, 2.9, 1.8, 3.2));
    dataset_delta.push_back(SensorData(5.4, 2.2, 19.6, 1.7, 2.2, 1.5));
    dataset_delta.push_back(SensorData(3.5, 18.8, 11.9, 2.0, 2.0, 2.3));
    dataset_delta.push_back(SensorData(14.0, 7.6, 1.3, 1.4, 3.5, 3.6));
    dataset_delta.push_back(SensorData(8.1, 12.4, 17.7, 1.6, 1.7, 1.2));
    dataset_delta.push_back(SensorData(20.0, 5.9, 9.2, 3.3, 2.7, 1.3));
    dataset_delta.push_back(SensorData(6.8, 13.5, 2.1, 1.9, 3.4, 2.7));
    dataset_delta.push_back(SensorData(17.2, 4.0, 14.9, 2.2, 1.3, 1.1));
    dataset_delta.push_back(SensorData(10.4, 8.3, 16.5, 2.5, 1.2, 2.1));

    // dataset theta
    dataset_theta.push_back(SensorData(7.2, 10.4, 13.8, 4.1, 5.5, 7.7));
    dataset_theta.push_back(SensorData(15.6, 7.7, 4.2, 7.2, 4.8, 6.4));
    dataset_theta.push_back(SensorData(11.9, 19.2, 8.7, 5.1, 6.4, 5.0));
    dataset_theta.push_back(SensorData(3.4, 1.1, 19.9, 4.9, 4.2, 7.9));
    dataset_theta.push_back(SensorData(16.3, 13.1, 11.0, 7.0, 7.3, 6.1));
    dataset_theta.push_back(SensorData(18.8, 6.0, 7.4, 6.5, 5.1, 7.7));
    dataset_theta.push_back(SensorData(19.7, 4.8, 9.2, 5.6, 7.3, 4.5));
    dataset_theta.push_back(SensorData(14.5, 3.3, 12.4, 4.0, 7.9, 6.6));
    dataset_theta.push_back(SensorData(12.2, 16.7, 7.1, 7.9, 6.2, 7.8));
    dataset_theta.push_back(SensorData(1.9, 19.5, 11.6, 6.1, 4.6, 5.5));
    dataset_theta.push_back(SensorData(17.3, 8.4, 14.2, 5.5, 8.0, 5.0));
    dataset_theta.push_back(SensorData(9.3, 11.6, 5.7, 4.8, 5.1, 7.9));
    dataset_theta.push_back(SensorData(4.7, 18.1, 15.2, 6.2, 6.7, 4.3));
    dataset_theta.push_back(SensorData(7.1, 10.2, 13.5, 7.4, 4.7, 8.0));
    dataset_theta.push_back(SensorData(6.6, 2.4, 14.0, 5.0, 6.6, 7.8));
    dataset_theta.push_back(SensorData(8.1, 20.0, 3.9, 6.8, 4.5, 6.3));
    dataset_theta.push_back(SensorData(1.6, 15.7, 11.3, 5.7, 4.4, 6.7));
    dataset_theta.push_back(SensorData(14.0, 2.9, 7.6, 7.2, 6.2, 5.1));
    dataset_theta.push_back(SensorData(17.9, 18.6, 9.5, 4.6, 5.9, 7.3));
    dataset_theta.push_back(SensorData(3.2, 11.4, 12.0, 6.3, 5.8, 7.4));
    dataset_theta.push_back(SensorData(10.7, 6.9, 4.4, 6.6, 7.4, 4.2));

    // dataset gamma
    dataset_gamma.push_back(SensorData(17.2, 10.3, 5.7, 83.1, 52.6, 75.4));
    dataset_gamma.push_back(SensorData(3.6, 14.2, 11.8, 37.5, 29.9, 90.1));
    dataset_gamma.push_back(SensorData(19.0, 7.1, 8.5, 102.3, 85.7, 70.2));
    dataset_gamma.push_back(SensorData(6.4, 13.9, 20.0, 55.6, 30.4, 60.8));
    dataset_gamma.push_back(SensorData(15.1, 2.7, 9.6, 89.7, 120.3, 130.2));
    dataset_gamma.push_back(SensorData(1.9, 18.4, 16.2, 41.9, 35.8, 45.6));
    dataset_gamma.push_back(SensorData(8.3, 5.5, 14.7, 110.6, 68.9, 139.9));
    dataset_gamma.push_back(SensorData(10.0, 17.6, 4.1, 77.8, 125.5, 96.3));
    dataset_gamma.push_back(SensorData(4.5, 9.2, 12.4, 139.2, 46.7, 50.1));
    dataset_gamma.push_back(SensorData(12.8, 16.9, 7.3, 100.0, 99.9, 32.5));
    dataset_gamma.push_back(SensorData(2.1, 11.7, 19.8, 103.4, 48.3, 140.0));
    dataset_gamma.push_back(SensorData(9.9, 20.0, 3.2, 27.7, 80.9, 78.4));
    dataset_gamma.push_back(SensorData(18.3, 6.8, 10.4, 133.1, 37.2, 88.9));
    dataset_gamma.push_back(SensorData(7.0, 15.5, 1.6, 58.4, 90.6, 120.7));
    dataset_gamma.push_back(SensorData(13.4, 8.2, 17.9, 65.5, 110.1, 135.8));
    dataset_gamma.push_back(SensorData(14.7, 4.3, 6.1, 85.9, 60.2, 105.4));
    dataset_gamma.push_back(SensorData(5.8, 12.6, 9.0, 79.7, 25.8, 130.0));
    dataset_gamma.push_back(SensorData(11.5, 3.7, 18.5, 69.1, 105.6, 115.2));
    dataset_gamma.push_back(SensorData(16.4, 1.8, 14.3, 45.5, 132.4, 81.3));
    dataset_gamma.push_back(SensorData(20.0, 10.5, 2.9, 129.8, 55.9, 28.6));
    dataset_gamma.push_back(SensorData(17.1, 19.7, 13.6, 75.2, 95.3, 64.7));
}


vector<SensorData> Dataset::getDataset1(){
    return dataset1;
}

vector<SensorData> Dataset::getDataset2(){
    return dataset2;
}

vector<SensorData> Dataset::getDatasetAlpha(){
    return dataset_alpha;
}

vector<SensorData> Dataset::getDatasetBeta(){
    return dataset_beta;
}

vector<SensorData> Dataset::getDatasetDelta(){
    return dataset_delta;
}

vector<SensorData> Dataset::getDatasetTheta(){
    return dataset_theta;
}

vector<SensorData> Dataset::getDatasetGamma(){
    return dataset_gamma;
}
