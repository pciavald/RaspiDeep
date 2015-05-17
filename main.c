/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: pciavald <pciavald@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2015/05/14 19:10:49 by pciavald          #+#    #+#             */
/*   Updated: 2015/05/16 16:16:07 by pciavald         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "RPI.h"
#include <stdlib.h>
#include <signal.h>

int		ctrl_system(int state)
{
	int		result;

	if (state == 1)
		result = system("./active_mode.sh");
	else
		result = system("./passive_mode.sh");
	if (WIFSIGNALED(result))
	{
		printf("Exited with signal %d\n", WTERMSIG(result));
		return (0);
	}
	return (1);
}

int		main(void)
{
	int		state = 0;

	gpio_init();
	gpio_in(4);
	while (42)
	{
		if (gpio_state(4, DN) == 1)
		{
			state = !state;
			while (gpio_state(4, DN) == 1)
				;
			if (ctrl_system(state) == 0)
				break ;
		}
		usleep(5000);
	}
	return (0);
}
