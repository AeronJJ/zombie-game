# Compiler and flags
CXX = g++
CXXFLAGS = -Wall -g -std=c++17 $(shell sdl2-config --cflags)
# Add include directories here
INCLUDES = -I./emu/inc -I./inc/Engine -I./inc/GameFiles -I./inc/GameFiles/Entities -I./inc/GameFiles/Scenes -I./inc/InputHandler -I./inc/Joystick

# Source files and object files
SRC_DIR = .
OBJ_DIR = obj

# Gather all .cpp files from all source directories (including root)
SRCS = $(shell find $(SRC_DIRS) -name '*.cpp')

# Convert .cpp files to .o object files (also for root)
OBJS = $(SRCS:%.cpp=$(OBJ_DIR)/%.o)

# Target executable
TARGET = Zombie-Game

# Default target to build the program
all: $(TARGET)

# Rule to link object files and create executable
$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -o $@ $^ $(shell sdl2-config --libs)

# Rule to compile source files into object files
$(OBJ_DIR)/%.o: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Automatically generate dependencies (.d files)
DEPFILES = $(OBJS:.o=.d)
-include $(DEPFILES)

$(OBJ_DIR)/%.d: %.cpp
	@mkdir -p $(dir $@)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -MM $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,$(OBJ_DIR)/\1.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$

# Clean up generated files
clean:
	rm -rf $(OBJ_DIR) $(TARGET) $(DEPFILES)