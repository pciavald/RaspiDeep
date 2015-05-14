/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: pciavald <pciavald@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2015/05/14 19:10:49 by pciavald          #+#    #+#             */
/*   Updated: 2015/05/14 20:16:44 by pciavald         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "RPI.h"

int		main(void)
{
	gpio_init();
	gpio_in(4);
	while (42)
	{
		if (GPIO_READ(4) == 0)
			printf ("closed\n");
		else if (GPIO_READ(4) == 16)
			printf("open\n");
	}
	return 0;
}
