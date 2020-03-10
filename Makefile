
APP:= deepstream-object-detect-karthick-test-app-1
CC = g++
TARGET_DEVICE = $(shell gcc -dumpmachine | cut -f1 -d -)

NVDS_VERSION:=4.0

LIB_INSTALL_DIR?=/opt/nvidia/deepstream/deepstream-$(NVDS_VERSION)/lib/

ifeq ($(TARGET_DEVICE),aarch64)
  CFLAGS:= -DPLATFORM_TEGRA
endif

SRCS:= $(wildcard *.cpp)  

INCS:= $(wildcard *.h)

PKGS:= gstreamer-1.0

OBJS:= $(SRCS:.cpp=.o)

CFLAGS+= -I../../../includes

CFLAGS+= `pkg-config --cflags $(PKGS)`

LIBS:= `pkg-config --libs $(PKGS)`

LIBS+= -lm \
       -Wl,-rpath,$(LIB_INSTALL_DIR)

LIBS+= -L$(LIB_INSTALL_DIR) -lnvdsgst_meta -lnvds_meta \
       -lgstrtspserver-1.0 -Wl,-rpath,$(LIB_INSTALL_DIR)

all: $(APP)

%.o: %.cpp $(INCS) Makefile
	$(CC) -c -o $@ $(CFLAGS) $<

$(APP): $(OBJS) Makefile
	$(CC) -o $(APP) $(OBJS) $(LIBS)

clean:
	rm -rf $(OBJS) $(APP)
