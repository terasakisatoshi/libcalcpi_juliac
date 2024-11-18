.PHONY: all clean

all:
	docker build -t libcalcpi-julia -f Dockerfile-julia .
	docker run --rm -it --mount type=bind,source=${CURDIR}/../,target=/home/ubuntu/work -w /home/ubuntu/work libcalcpi-julia bash -c "make run"
	#docker build -t libcalcpi-runtime -f Dockerfile-runtime .
	#docker run --rm -it --mount type=bind,source=${CURDIR}/../,target=/home/ubuntu/work -w /home/ubuntu/work libcalcpi-runtime bash # -c "LD_LIBRARY_PATH=. ./a.out 

clean:
	docker run --rm -it --mount type=bind,source=${CURDIR}/../,target=/home/ubuntu/work -w /home/ubuntu/work libcalcpi-julia bash -c "make clean"
