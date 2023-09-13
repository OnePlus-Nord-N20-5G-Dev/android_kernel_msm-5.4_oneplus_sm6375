# Copyright (C), 2008-2030, OPLUS Mobile Comm Corp., Ltd
### All rights reserved.
###
### File: - OplusKernelEnvConfig.mk
### Description:
###     you can get the oplus feature variables set in android side in this file
###     this file will add global macro for common oplus added feature
###     BSP team can do customzation by referring the feature variables
### Version: 1.0
### Date: 2020-03-18
### Author: Liang.Sun
###
### ------------------------------- Revision History: ----------------------------
### <author>                        <date>       <version>   <desc>
### ------------------------------------------------------------------------------
##################################################################################

-include oplus_native_features.mk
#bsp team should check and modify neccessary to make sure the following macro is allowed to declare
#can add or delete item for the top level macro
ALLOWED_MCROS := OPLUS_FEATURE_POWERINFO_FTM \
OPLUS_FEATURE_AGINGTEST \
OPLUS_FEATURE_WIFI_BDF  \
OPLUS_FEATURE_WIFI_MAC  \
OPLUS_FEATURE_WIFI_SLA  \
OPLUS_FEATURE_DHCP \
OPLUS_FEATURE_IPV6_OPTIMIZE  \
OPLUS_FEATURE_SELINUX_CONTROL_LOG  \
OPLUS_FEATURE_MODEM_MINIDUMP \
OPLUS_FEATURE_THEIA \
OPLUS_FEATURE_APP_MONITOR \
OPLUS_FEATURE_DATA_EVAL \
OPLUS_FEATURE_QCOM_WATCHDOG \
OPLUS_FEATURE_TASK_CPUSTATS \
OPLUS_FEATURE_DNS_HOOK \
OPLUS_FEATURE_AUDIODETECT \
OPLUS_AUDIO_PA_BOOST_VOLTAGE \
OPLUS_FEATURE_SWITCH_CHECK \
OPLUS_FEATURE_OLC \
OPLUS_FEATURE_DATA_MODULE

KBUILD_CFLAGS += -DOPLUS_FEATURE_MULTI_FREEAREA
KBUILD_CFLAGS += -DOPLUS_FEATURE_HEALTHINFO
KBUILD_CFLAGS += -DOPLUS_FEATURE_POWERINFO_FTM
KBUILD_CFLAGS += -DOPLUS_FEATURE_POWERINFO_STANDBY
KBUILD_CFLAGS += -DOPLUS_FEATURE_POWERINFO_STANDBY_DEBUG
KBUILD_CFLAGS += -DOPLUS_FEATURE_POWERINFO_RPMH

KBUILD_CFLAGS += -DOPLUS_FEATURE_WIFI_LIMMITBGSPEED
KBUILD_CFLAGS += -DOPLUS_FEATURE_WIFI_BDF
KBUILD_CFLAGS += -DOPLUS_FEATURE_WIFI_SLA
KBUILD_CFLAGS += -DOPLUS_FEATURE_DHCP
KBUILD_CFLAGS += -DOPLUS_FEATURE_PERFORMANCE
KBUILD_CFLAGS += -DOPLUS_FEATURE_HANS_FREEZE

KBUILD_CFLAGS += -DOPLUS_FEATURE_KTV
KBUILD_CFLAGS += -DOPLUS_ARCH_EXTENDS
KBUILD_CFLAGS += -DOPLUS_FEATURE_VIRTUAL_RESERVE_MEMORY
KBUILD_CFLAGS += -DOPLUS_AUDIO_PA_BOOST_VOLTAGE
KBUILD_CFLAGS += -DOPLUS_FEATURE_SPEAKER_MUTE
KBUILD_CFLAGS += -DOPLUS_FEATURE_AUDIO_FTM
KBUILD_CFLAGS += -DOPLUS_FEATURE_ADSP_RECOVERY

KBUILD_CFLAGS += -DOPLUS_FEATURE_TP_BASIC

#only declare a macro if nativefeature is define and also added in above ALLOWED_MCROS
$(foreach myfeature,$(ALLOWED_MCROS),\
    $(if $(strip $($(myfeature))),\
         $(eval KBUILD_CFLAGS += -D$(myfeature)) \
         $(eval KBUILD_CPPFLAGS += -D$(myfeature)) \
         $(eval CFLAGS_KERNEL += -D$(myfeature)) \
         $(eval CFLAGS_MODULE += -D$(myfeature)) \
))

# BSP team can do customzation by referring the feature variables
ifeq ($(OPLUS_FEATURE_AOD_RAMLESS),yes)
KBUILD_CFLAGS += -DOPLUS_FEATURE_AOD_RAMLESS
KBUILD_CPPFLAGS += -DOPLUS_FEATURE_AOD_RAMLESS
CFLAGS_KERNEL += -DOPLUS_FEATURE_AOD_RAMLESS
CFLAGS_MODULE += -DOPLUS_FEATURE_AOD_RAMLESS
endif
