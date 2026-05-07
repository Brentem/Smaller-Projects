module snake_game;
import raylib5::rl;
import std::math::random;
import std::io;
import types;
import snake;

const int BLOCK_WIDTH = 16;
const int BLOCK_HEIGHT = 16;

const int BLOCK_COUNT_HORIZONTAL = 64;
const int BLOCK_COUNT_VERTICAL = 64;

const int SCREEN_WIDTH = (BLOCK_WIDTH * BLOCK_COUNT_HORIZONTAL);
const int SCREEN_HEIGHT = (BLOCK_HEIGHT * BLOCK_COUNT_VERTICAL);

// NOTE: See difference in declaring and accessing 2d array.
BlockType[BLOCK_COUNT_HORIZONTAL][BLOCK_COUNT_VERTICAL] grid;

double prev_time;
double curr_time;

int score = 0;
bool score_changed = false;
MovementDirection direction = MOVING_UP;
bool quit_game = false;

Snake snake;

fn void initialize()
{
    rl::initWindow(SCREEN_WIDTH, SCREEN_HEIGHT, "Snake");
    rl::setTargetFPS(60);

	int player_x_index = (BLOCK_COUNT_HORIZONTAL / 2);
	int player_y_index = (BLOCK_COUNT_VERTICAL / 2);
	snake::initialize(&snake, player_x_index, player_y_index);

	prev_time = rl::getTime();

	set_border_blocks();

	set_food_block();
}

fn void clear_blocks()
{
	for(int y = 0; y < BLOCK_COUNT_VERTICAL; y++)
	{
		for(int x = 0; x < BLOCK_COUNT_HORIZONTAL; x++)
		{
			if(grid[y][x] != FOOD_BLOCK)
			{
				grid[y][x] = NO_BLOCK;
			}
		}
	}
}

fn void set_border_blocks()
{
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

		if(catch excuse = snake::move(&snake, direction))
		{
			io::printfn("snake::add() gave an Excuse: %s", excuse);
		}
		SnakeBlock snake_head = snake.blocks[0];

		if((grid[snake_head.y_index][snake_head.x_index] == BlockType.BORDER_BLOCK) ||
		(grid[snake_head.y_index][snake_head.x_index] == BlockType.PLAYER_BODY_BLOCK))
		{
			quit_game = true;
		}

		if(grid[snake_head.y_index][snake_head.x_index] == BlockType.FOOD_BLOCK)
		{
			if(catch excuse = snake::add(&snake))
			{
				io::printfn("snake::add() gave an Excuse: %s", excuse);
			}

			score++;
			grid[snake_head.y_index][snake_head.x_index] = BlockType.NO_BLOCK;
			score_changed = true;
		}

		clear_blocks();
		set_border_blocks();

		for(int i = 0; i < snake.blocks.len(); i++)
		{
			SnakeBlock curr_block = snake.blocks[i];
			grid[curr_block.y_index][curr_block.x_index] = curr_block.type;
		}
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

					if(grid[y][x] == BlockType.PLAYER_BODY_BLOCK)
					{
						// Draw Body of Player
						rl::drawRectangle(posX, posY, BLOCK_WIDTH, BLOCK_HEIGHT, rl::LIME);
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
