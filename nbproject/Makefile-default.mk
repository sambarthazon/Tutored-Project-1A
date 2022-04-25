#
# Generated Makefile - do not edit!
#
# Edit the Makefile in the project folder instead (../Makefile). Each target
# has a -pre and a -post target defined where you can add customized code.
#
# This makefile implements configuration specific macros and targets.


# Include project Makefile
ifeq "${IGNORE_LOCAL}" "TRUE"
# do not include local makefile. User is passing all local related variables already
else
include Makefile
# Include makefile containing local settings
ifeq "$(wildcard nbproject/Makefile-local-default.mk)" "nbproject/Makefile-local-default.mk"
include nbproject/Makefile-local-default.mk
endif
endif

# Environment
MKDIR=gnumkdir -p
RM=rm -f 
MV=mv 
CP=cp 

# Macros
CND_CONF=default
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
IMAGE_TYPE=debug
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/Test_Robot_PIC16F886.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
else
IMAGE_TYPE=production
OUTPUT_SUFFIX=hex
DEBUGGABLE_SUFFIX=cof
FINAL_IMAGE=dist/${CND_CONF}/${IMAGE_TYPE}/Test_Robot_PIC16F886.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}
endif

ifeq ($(COMPARE_BUILD), true)
COMPARISON_BUILD=
else
COMPARISON_BUILD=
endif

ifdef SUB_IMAGE_ADDRESS

else
SUB_IMAGE_ADDRESS_COMMAND=
endif

# Object Directory
OBJECTDIR=build/${CND_CONF}/${IMAGE_TYPE}

# Distribution Directory
DISTDIR=dist/${CND_CONF}/${IMAGE_TYPE}

# Source Files Quoted if spaced
SOURCEFILES_QUOTED_IF_SPACED=Test_Robot_PIC16F886.c

# Object Files Quoted if spaced
OBJECTFILES_QUOTED_IF_SPACED=${OBJECTDIR}/Test_Robot_PIC16F886.o
POSSIBLE_DEPFILES=${OBJECTDIR}/Test_Robot_PIC16F886.o.d

# Object Files
OBJECTFILES=${OBJECTDIR}/Test_Robot_PIC16F886.o

# Source Files
SOURCEFILES=Test_Robot_PIC16F886.c


CFLAGS=
ASFLAGS=
LDLIBSOPTIONS=

############# Tool locations ##########################################
# If you copy a project from one host to another, the path where the  #
# compiler is installed may be different.                             #
# If you open this project with MPLAB X in the new host, this         #
# makefile will be regenerated and the paths will be corrected.       #
#######################################################################
# fixDeps replaces a bunch of sed/cat/printf statements that slow down the build
FIXDEPS=fixDeps

.build-conf:  ${BUILD_SUBPROJECTS}
ifneq ($(INFORMATION_MESSAGE), )
	@echo $(INFORMATION_MESSAGE)
endif
	${MAKE}  -f nbproject/Makefile-default.mk dist/${CND_CONF}/${IMAGE_TYPE}/Test_Robot_PIC16F886.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}

# ------------------------------------------------------------------------------------
# Rules for buildStep: compile_single_mode
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
${OBJECTDIR}/Test_Robot_PIC16F886.o: Test_Robot_PIC16F886.c  nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} "${OBJECTDIR}" 
	${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} -dc -FM -p16f886 -cif Test_Robot_PIC16F886.c  -Odist/${CND_CONF}/${IMAGE_TYPE} -odist/${CND_CONF}/${IMAGE_TYPE}/Test_Robot_PIC16F886.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX} -a${OBJECTDIR}/Test_Robot_PIC16F886.asm -CFdist/${CND_CONF}/${IMAGE_TYPE}/Test_Robot_PIC16F886.X.${IMAGE_TYPE}.cof
	
else
${OBJECTDIR}/Test_Robot_PIC16F886.o: Test_Robot_PIC16F886.c  nbproject/Makefile-${CND_CONF}.mk
	${MKDIR} "${OBJECTDIR}" 
	${MKDIR} dist/${CND_CONF}/${IMAGE_TYPE} 
	${MP_CC} -dc -FM -p16f886 -cif Test_Robot_PIC16F886.c  -Odist/${CND_CONF}/${IMAGE_TYPE} -odist/${CND_CONF}/${IMAGE_TYPE}/Test_Robot_PIC16F886.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX} -a${OBJECTDIR}/Test_Robot_PIC16F886.asm -CFdist/${CND_CONF}/${IMAGE_TYPE}/Test_Robot_PIC16F886.X.${IMAGE_TYPE}.cof
	
endif

# ------------------------------------------------------------------------------------
# Rules for buildStep: link_not_used
ifeq ($(TYPE_IMAGE), DEBUG_RUN)
dist/${CND_CONF}/${IMAGE_TYPE}/Test_Robot_PIC16F886.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk    
	
else
dist/${CND_CONF}/${IMAGE_TYPE}/Test_Robot_PIC16F886.X.${IMAGE_TYPE}.${OUTPUT_SUFFIX}: ${OBJECTFILES}  nbproject/Makefile-${CND_CONF}.mk   
	
endif


# Subprojects
.build-subprojects:


# Subprojects
.clean-subprojects:

# Clean Targets
.clean-conf: ${CLEAN_SUBPROJECTS}
	${RM} -r build/default
	${RM} -r dist/default

# Enable dependency checking
.dep.inc: .depcheck-impl

DEPFILES=$(shell mplabwildcard ${POSSIBLE_DEPFILES})
ifneq (${DEPFILES},)
include ${DEPFILES}
endif
