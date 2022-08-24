# custom-vision-parser-lib-for-nvidia-deepstream
The goal of this repo is to be able to generate the custom vision parser library automatically according to your CUDA version and Deepstream Version   

[!note] The parser lib should be able to be generated under the situation that the Nvidia deepstream directories naming rules for the new version don’t change. If the directories of the Nvidia deepstream have changed, you can reference the Dockerfile directly to change the base image and corresponding directory to compile the parser lib. 


## Content
| File             | Description                                                   |
|-------------------------|---------------------------------------------------------------|
| `readme.md`             | This readme file                                              |

## amd64 folder Content
| File             | Description                                                   |
|-------------------------|---------------------------------------------------------------|
| `cv`    | The parser file and Makefile needed for building the custom vision library parser |
| `lib_output`    | The folder using to store the parser library you generated |
| `Dockerfile_amd_arg.dockerfile`    | The dockerfile for generating the lib according to your CUDA/ Deepstream Version |
| `libnvdsinfer_custom_impl_Yolo_arm_ds61.so`    | The custom vision parser lib of deepstream 6.1 & CUDA 11.6 for amd64 architecture |

## arm64 folder Content
| File             | Description                                                   |
|-------------------------|---------------------------------------------------------------|
| `libnvdsinfer_custom_impl_Yolo_amd_ds61.so`    | The custom vision parser lib of deepstream 6.1 & CUDA 11.6 for arm64 architecture |

## Steps

#### 1. Clone the repo

#### 2. Open the terminal and cd to the corresponding folder for the architecture you want to build for
For example:

```
      cd amd64
``` 
  
   
#### 3. Docker build with the Deepstream version(DS_VER) and CUDA version(CUDA_VER) you set 
```
      docker build -f Dockerfile_amd_arg.dockerfile --build-arg DS_VER=6.1 --build-arg CUDA_VER=11.6 -t test . 
``` 

#### 4. Copy the parser library generated in the container to the host
```
      docker cp $(docker create test):/cv_parser_lib/libnvdsinfer_custom_impl_Yolo.so $(pwd)/lib_output/
``` 

#### 5. Get your parser library in the lib_output folder
You should be able to see the corresponding parser lib has been generated in the lib_output folder





## Credit and references 
[NVIDIA-Deepstream-Azure-IoT-Edge-on-a-NVIDIA-Jetson-Nano](https://github.com/Azure-Samples/NVIDIA-Deepstream-Azure-IoT-Edge-on-a-NVIDIA-Jetson-Nano)
