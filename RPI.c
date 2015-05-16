/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   RPI.c                                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: pciavald <pciavald@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2015/05/14 18:46:49 by pciavald          #+#    #+#             */
/*   Updated: 2015/05/16 15:02:29 by pciavald         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "RPI.h"
#include <fcntl.h>

t_bcm2835_peripheral gpio = {GPIO_BASE, 0, 0, 0};

int		gpio_state(int pin, int mode)
{
	if ((int)(GPIO_READ(pin)) == 16)
		return (mode == UP ? 1 : 0);
	return (mode == DN ? 1 : 0);
}

void	gpio_on(int pin)
{
	GPIO_SET = 1 << pin;
}

void	gpio_off(int pin)
{
	GPIO_CLR = 1 << pin;
}

void	gpio_in(int pin)
{
	INP_GPIO(pin);
}

void	gpio_out(int pin)
{
	INP_GPIO(pin);
	OUT_GPIO(pin);
}

int		gpio_init(void)
{
	if (map_peripheral(&gpio) == -1)
	{
		printf("Failed to map the physical GPIO.\n");
		return (-1);
	}
	return (0);
}

// Exposes the physical address defined in the passed structure using mmap on /dev/mem
int		map_peripheral(t_bcm2835_peripheral * p)
{
	if ((p->mem_fd = open("/dev/mem", O_RDWR|O_SYNC)) < 0)
	{
		printf("Failed to open /dev/mem, try checking permissions.\n");
		return (-1);
	}

	p->map = mmap(
			NULL,
			BLOCK_SIZE,
			PROT_READ|PROT_WRITE,
			MAP_SHARED,
			p->mem_fd,	// File descriptor to physical memory virtual file '/dev/mem'
			p->addr_p	// Address in physical map that we want this memory block to expose
			);

	if (p->map == MAP_FAILED)
	{
		perror("mmap");
		return (-1);
	}

	p->addr = (volatile unsigned int *)p->map;

	return (0);
}

void	unmap_peripheral(t_bcm2835_peripheral * p)
{
	munmap(p->map, BLOCK_SIZE);
	close(p->mem_fd);
}
