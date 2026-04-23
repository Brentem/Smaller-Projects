module snake;
import raylib5::rl;
import std::math::random;

const int BLOCK_WIDTH = 16;
const int BLOCK_HEIGHT = 16;

const int BLOCK_COUNT_HORIZONTAL = 64;
const int BLOCK_COUNT_VERTICAL = 64;

const int SCREEN_WIDTH = (BLOCK_WIDTH * BLOCK_COUNT_HORIZONTAL);
const int SCREEN_HEIGHT = (BLOCK_HEIGHT * BLOCK_COUNT_VERTICAL);

enum InputEvent
{
	NO_INPUT_EVENT,
	INPUT_EVENT_KEY_RIGHT,
	INPUT_EVENT_KEY_LEFT
}

enum MovementDirection
{
	MOVING_UP,
	MOVING_DOWN,
	MOVING_RIGHT,
	MOVING_LEFT
}

enum BlockType
{
	NO_BLOCK,
	PLAYER_HEAD_BLOCK,
	PLAYER_BODY_BLOCK,
	FOOD_BLOCK,
	BORDER_BLOCK
}

// NOTE: See difference in declaring and accessing 2d array.
BlockType[BLOCK_COUNT_HORIZONTAL][BLOCK_COUNT_VERTICAL] grid;

double prev_time;
double curr_time;
int player_x_index = (BLOCK_COUNT_HORIZONTAL / 2);
int player_y_index = (BLOCK_COUNT_VERTICAL / 2);

int score = 0;
bool score_changed = false;
MovementDirection direction = MOVING_UP;
bool quit_game = false;

fn void initialize()
{
    rl::initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Snake");
    rl::setTargetFPS(60);

	grid[player_y_index][player_x_index] = BlockType.PLAYER_HEAD_BLOCK;
	prev_time = rl::getTime();

	for(int i = 0; i < BLOCK_COUNT_VERTICAL; i++)
	{
		grid[i][0] = BORDER_BLOCK;
		grid[i][(BLOCK_COUNT_HORIZONTAL - 1)] = BORDER_BLOCK;
	}

	for(int i = 0; i < BLOCK_COUNT_HORIZONTAL; i++)
	{
		grid[0][i] = BORDER_BLOCK;
		grid[(BLOCK_COUNT_VERTICAL - 1)][i] = BORDER_BLOCK;
	}

	set_food_block();
}

fn void set_food_block()
{
	bool success = false;

	while(!success)
	{
		int x = rand_in_range(0, (BLOCK_COUNT_HORIZONTAL - 1));
		int y = rand_in_range(0, (BLOCK_COUNT_VERTICAL - 1));

		if(grid[y][x] == BlockType.NO_BLOCK)
		{
			grid[y][x] = BlockType.FOOD_BLOCK;
			success = true;
		}
	}
}

fn InputEvent handle_input()
{
	InputEvent event = InputEvent.NO_INPUT_EVENT;

	if(rl::isKeyPressed(rl::KEY_RIGHT))
	{
		event = InputEvent.INPUT_EVENT_KEY_RIGHT;
	}

	if(rl::isKeyPressed(rl::KEY_LEFT))
	{
		event = InputEvent.INPUT_EVENT_KEY_LEFT;
	}

	return event;
}

// Moving Up: Left Key --> Moving Left ; Right Key --> Moving Right
// Moving Down: Left Key --> Moving Right ; Right Key --> Moving Left
// Moving Right: Left Key --> Moving Up ; Right Key --> Moving Down
// Moving Left: Left Key --> Moving Down ; Right Key --> Moving Up
fn void change_movement(InputEvent event)
{
	MovementDirection newDirection = direction;

	// Moving Up
	newDirection = ((direction == MOVING_UP) && (event == INPUT_EVENT_KEY_LEFT)) ? MOVING_LEFT : newDirection;
	newDirection = ((direction == MOVING_UP) && (event == INPUT_EVENT_KEY_RIGHT)) ? MOVING_RIGHT : newDirection;

	// Moving Down
	newDirection = ((direction == MOVING_DOWN) && (event == INPUT_EVENT_KEY_LEFT)) ? MOVING_RIGHT : newDirection;
	newDirection = ((direction == MOVING_DOWN) && (event == INPUT_EVENT_KEY_RIGHT)) ? MOVING_LEFT : newDirection;

	// Moving Right
	newDirection = ((direction == MOVING_RIGHT) && (event == INPUT_EVENT_KEY_LEFT)) ? MOVING_UP : newDirection;
	newDirection = ((direction == MOVING_RIGHT) && (event == INPUT_EVENT_KEY_RIGHT)) ? MOVING_DOWN : newDirection;

	// Moving Left
	newDirection = ((direction == MOVING_LEFT) && (event == INPUT_EVENT_KEY_LEFT)) ? MOVING_DOWN : newDirection;
	newDirection = ((direction == MOVING_LEFT) && (event == INPUT_EVENT_KEY_RIGHT)) ? MOVING_UP : newDirection;

	direction = newDirection;
}

fn void apply_movement()
{
	curr_time = rl::getTime();
	if((curr_time - prev_time) >= 0.2)
	{
		prev_time = curr_time;
		grid[player_y_index][player_x_index] = BlockType.NO_BLOCK;

		// TODO: Consider creating a state machine to handle different directions.
		// TODO: Also check if index is valid.
		// NOTE: C3 uses implicit break for switch statements.
		switch(direction)
		{
		case MOVING_UP:
			player_y_index--;
		case MOVING_DOWN:
			player_y_index++;
		case MOVING_RIGHT:
			player_x_index++;
		case MOVING_LEFT:
			player_x_index--;
		default:
			// TODO: Error handling?
		}

		if(grid[player_y_index][player_x_index] == BlockType.BORDER_BLOCK)
		{
			quit_game = true;
		}

		if(grid[player_y_index][player_x_index] == BlockType.FOOD_BLOCK)
		{
			score++;
			grid[player_y_index][player_x_index] = BlockType.NO_BLOCK;
			score_changed = true;
		}

		grid[player_y_index][player_x_index] = BlockType.PLAYER_HEAD_BLOCK;
	}
}

fn int main()
{
	initialize();

    while (!quit_game)
    {
		quit_game = rl::windowShouldClose();

		if(score_changed)
		{
			score_changed = false;
			set_food_block();
		}

		InputEvent event = handle_input();

		change_movement(event);

		apply_movement();

        rl::clearBackground(rl::BLACK);

        rl::beginDrawing();
		{
			for(int y = 0; y < BLOCK_COUNT_VERTICAL; y++)
			{
				for(int x = 0; x < BLOCK_COUNT_HORIZONTAL; x++)
				{
					int posX = x * BLOCK_WIDTH;
					int posY = y * BLOCK_HEIGHT;

					if(grid[y][x] == BlockType.FOOD_BLOCK)
					{
						// Draw Food
						rl::drawRectangle(posX, posY, BLOCK_WIDTH, BLOCK_HEIGHT, rl::RED);
					}

					if(grid[y][x] == BlockType.PLAYER_HEAD_BLOCK)
					{
						// Draw Player
						rl::drawRectangle(posX, posY, BLOCK_WIDTH, BLOCK_HEIGHT, rl::GREEN); // Head of snake
					}

					if(grid[y][x] == BlockType.BORDER_BLOCK)
					{
						// Draw Border
						rl::drawRectangle(posX, posY, BLOCK_WIDTH, BLOCK_HEIGHT, rl::WHITE); 
					}
				}
			}
		}
        rl::endDrawing();
    }

    rl::closeWindow();

    return 0;
}
