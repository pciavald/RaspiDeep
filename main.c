/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: pciavald <pciavald@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2015/05/14 19:10:49 by pciavald          #+#    #+#             */
/*   Updated: 2015/05/14 20:35:42 by pciavald         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "RPI.h"

int		main(void)
{
	gpio_init();
	gpio_in(4);
	while (42)
	{
		//if (gpio_state(4, DN))
		//	printf("magnet\n");
		printf("%i\n", GPIO_READ(4));
	}
	return (0);
}
