/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: pciavald <pciavald@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2015/05/14 19:10:49 by pciavald          #+#    #+#             */
/*   Updated: 2015/05/14 19:16:51 by pciavald         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "RPI.h"

int		main(void)
{
	if (map_peripheral(&gpio) == -1)
	{
		printf("Failed to map the physical GPIO.\n");
		return -1;
	}

	// Define pin 7 as output
	INP_GPIO(4);
	OUT_GPIO(4);

	while (42)
	{
		// Toggle pin 7 (blink a led!)
		GPIO_SET = 1 << 4;
		sleep(1);

		GPIO_CLR = 1 << 4;
		sleep(1);
	}

	return 0;
}
