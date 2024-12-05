# Prepare enviroment for baremetal-runtime
NAME:=freertos
ROOT_DIR:=$(realpath .)
BUILD_DIR:=$(ROOT_DIR)/build/$(PLATFORM)

# Setup baremetal-runtime build
freertos_dir:=$(ROOT_DIR)/src/freertos-over-bao
bmrt_dir:=$(freertos_dir)/src/baremetal-runtime
# bmrt_dir:=$(ROOT_DIR)/src/baremetal-runtime
include $(bmrt_dir)/setup.mk

# Setup FreeRTOS app build
frtos_app_dir:=$(ROOT_DIR)/src/freertos-app
app_src_dir:=$(frtos_app_dir)
include $(frtos_app_dir)/sources.mk
C_SRC+=$(addprefix $(app_src_dir)/, $(src_c_srcs))
include $(frtos_app_dir)/setup.mk

# Freertos kernel sources
freertos_kernel_dir:=$(freertos_dir)/src/freertos
SRC_DIRS+=$(freertos_kernel_dir) $(freertos_memmng_dir)
INC_DIRS+=$(freertos_kernel_dir)/include
C_SRC+=$(wildcard $(freertos_kernel_dir)/*.c)
freertos_memmng_dir:=$(freertos_kernel_dir)/portable/MemMang
C_SRC+=$(freertos_memmng_dir)/heap_4.c

# Freertos port arch-specific
arch_dir=$(freertos_dir)/src/arch/$(ARCH)
SRC_DIRS+=$(arch_dir)
INC_DIRS+=$(arch_dir)/inc
-include $(arch_dir)/arch.mk
-include $(arch_dir)/sources.mk
C_SRC+=$(addprefix $(arch_dir)/, $(arch_c_srcs))
ASM_SRC+=$(addprefix $(arch_dir)/, $(arch_s_srcs))

# Include the final baremetal-runtime build
include $(bmrt_dir)/build.mk