#include "RPI.h"
#include <stdlib.h>
#include <signal.h>
#include <string.h>

int		ctrl_system(int state, char * path)
{
	int		result;
	char	fullpath[256] = {0};

	strncat(fullpath, path, strlen(path));
	if (fullpath[strlen(path)] != '/')
		strncat(fullpath, "/", 1);
	if (state == 1)
	{
		strncat(fullpath, "script/active_mode.sh", 21);
		result = system(fullpath);
	}
	else
	{
		strncat(fullpath, "script/passive_mode.sh", 22);
		result = system(fullpath);
	}
	if (WIFSIGNALED(result))
	{
		printf("Exited with signal %d\n", WTERMSIG(result));
		return (0);
	}
	return (1);
}

int		main(int argc, char ** argv)
{
	int		state = 0;

	if (argc != 2)
		exit (-1);
	gpio_init();
	gpio_in(4);
	while (42)
	{
		if (gpio_state(4, DN) == 1)
		{
			state = !state;
			while (gpio_state(4, DN) == 1)
				;
			if (ctrl_system(state, argv[1]) == 0)
				break ;
		}
		usleep(5000);
	}
	return (0);
}
