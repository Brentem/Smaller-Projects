module snake;
import raylib5::rl;
import std::math::random;

const int BLOCK_WIDTH = 16;
const int BLOCK_HEIGHT = 16;

const int BLOCK_COUNT_HORIZONTAL = 64;
const int BLOCK_COUNT_VERTICAL = 64;

const int SCREEN_WIDTH = (BLOCK_WIDTH * BLOCK_COUNT_HORIZONTAL);
const int SCREEN_HEIGHT = (BLOCK_HEIGHT * BLOCK_COUNT_VERTICAL);

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

fn int main()
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

    while (!rl::windowShouldClose())
    {
		if(score_changed)
		{
			score_changed = false;
			set_food_block();
		}

		if(rl::isKeyPressed(rl::KEY_RIGHT))
		{
			direction = MOVING_RIGHT;
		}

		if(rl::isKeyPressed(rl::KEY_LEFT))
		{
			direction = MOVING_LEFT;
		}

		if(rl::isKeyPressed(rl::KEY_UP))
		{
			direction = MOVING_UP;
		}

		if(rl::isKeyPressed(rl::KEY_DOWN))
		{
			direction = MOVING_DOWN;
		}

		curr_time = rl::getTime();
		if((curr_time - prev_time) >= 0.2)
		{
			prev_time = curr_time;
			grid[player_y_index][player_x_index] = BlockType.NO_BLOCK;

			// TODO: Consider creating a state machine to handle different directions.
			// TODO: Also check if index is valid.
			switch (direction)
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
				
			}

			if(grid[player_y_index][player_x_index] == BlockType.BORDER_BLOCK)
			{
				break; // Exit game
			}

			if(grid[player_y_index][player_x_index] == BlockType.FOOD_BLOCK)
			{
				score++;
				grid[player_y_index][player_x_index] = BlockType.NO_BLOCK;
				score_changed = true;
			}

			grid[player_y_index][player_x_index] = BlockType.PLAYER_HEAD_BLOCK;
		}


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
