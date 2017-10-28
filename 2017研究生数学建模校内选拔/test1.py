import sys, os
import random
import numpy as np
from collections import defaultdict


def getRandomData(minNum, maxNum, pointCount):
    if pointCount <= 0:
        pointCount = 50
    if minNum > maxNum:
        minNum, maxNum = maxNum, minNum
    if minNum == maxNum and minNum != 0:
        minNum = maxNum / 2;
    allPoints = []
    i = 0
    while i < pointCount:
        tmpPoint = [random.randint(minNum, maxNum), random.randint(minNum, maxNum)]
        if tmpPoint not in allPoints:
            allPoints.append(tmpPoint)
            i += 1
    return allPoints


def distance(vec1, vec2):
    return ((vec1[0] - vec2[0]) ** 2 + (vec1[1] - vec2[1]) ** 2) ** 0.5


def dbscan(allPoints, minDistance, minPointCount):
    corePoints = []
    otherPoints = []
    noNoisePoints = []
    borderPoints= []
    noisePoints = []


    for point in allPoints:
        point.append(0)
        count = 0
        for otherPoint in allPoints:
            if distance(point, otherPoint) <= minDistance:
                count += 1
        if count >= (minPointCount + 1):
            #corePoints.append(point)
            noNoisePoints.append(point)
        else:
            otherPoints.append(point)
        count = 0

    '''
    for point in otherPoints:
        for corePoint in corePoints:
            if distance(point, corePoint) <= minDistance:
                borderPoints.append(point)
                noNoisePoints.append(point)


    for point in allPoints:
        if point not in corePoints and point not in borderPoints:
            noisePoints.append(point)

    
    label = 0
    for point in corePoints:
        if point[-1] == 0:
            label += 1
            point[-1] = label
        for noNoisePoint in noNoisePoints:
            dist = distance(point, noNoisePoint)
            if dist <= minDistance and noNoisePoint[-1] == 0:
                noNoisePoint[-1] = point[-1]


    cluster = defaultdict(lambda: [[],[]])
    for point in noNoisePoints:
        cluster[point[-1]][0].append(point[0])
        cluster[point[-1]][1].append(point[1])
    print (cluster)
    '''
    
    print ("########################################################")


if __name__ == '__main__':
    #allPoints = getRandomData(1, 50, 100)\
    imgxy=np.load('imgxy.npy')
    imgxy = list(imgxy)
    for i in range(len(imgxy)):
        imgxy[i]=list(imgxy[i])
    #print(imgxy)
    dbscan(imgxy, 50, 40)
    np.save('noisexy.npy',otherPoints)