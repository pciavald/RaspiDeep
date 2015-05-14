/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: pciavald <pciavald@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2015/05/14 19:10:49 by pciavald          #+#    #+#             */
/*   Updated: 2015/05/14 19:45:35 by pciavald         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "RPI.h"

int		main(void)
{
	//gpio_init();
	if (map_peripheral(&gpio) == -1)
	{
		printf("Failed to map the physical GPIO.\n");
		return (-1);
	}
	gpio_in(4);
	while (42)
	{
		// Toggle pin 7 (blink a led!)
		gpio_on(4);
		sleep(1);

		gpio_off(4);
		sleep(1);
	}

	return 0;
}
