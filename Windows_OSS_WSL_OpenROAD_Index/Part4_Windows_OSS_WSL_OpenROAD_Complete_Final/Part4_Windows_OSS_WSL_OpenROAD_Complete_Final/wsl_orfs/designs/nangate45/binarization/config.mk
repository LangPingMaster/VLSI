export PLATFORM = nangate45
export DESIGN_NAME = binarization
export DESIGN_NICKNAME = binarization
export VERILOG_FILES = $(DESIGN_HOME)/src/$(DESIGN_NICKNAME)/binarization.v
export SDC_FILE = $(DESIGN_HOME)/$(PLATFORM)/$(DESIGN_NICKNAME)/constraint.sdc
# Explicit floorplan fixes PDN-0185
export DIE_AREA = 0 0 60 60
export CORE_AREA = 5 5 55 55
export PLACE_DENSITY = 0.55
export TNS_END_PERCENT = 100
