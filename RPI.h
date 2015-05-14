/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   RPI.h                                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: pciavald <pciavald@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2015/05/14 18:38:50 by pciavald          #+#    #+#             */
/*   Updated: 2015/05/14 19:42:15 by pciavald         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef RPI_H
# define RPI_H
# include <stdio.h>
# include <sys/mman.h>
# include <sys/types.h>
# include <sys/stat.h>
# include <unistd.h>

# define BCM2708_PERI_BASE	0x20000000
# define GPIO_BASE			(BCM2708_PERI_BASE + 0x200000)
# define BLOCK_SIZE			(4*1024)

// GPIO setup macros. Always use INP_GPIO(x) before using OUT_GPIO(x)
# define INP_GPIO(g)		*(gpio.addr + ((g)/10)) &= ~(7<<(((g)%10)*3))
# define OUT_GPIO(g)		*(gpio.addr + ((g)/10)) |=  (1<<(((g)%10)*3))
# define SET_GPIO_ALT(g,a)	*(gpio.addr + (((g)/10))) |= (((a)<=3?(a) + 4:(a)==4?3:2)<<(((g)%10)*3))
# define GPIO_SET			*(gpio.addr + 7)
# define GPIO_CLR			*(gpio.addr + 10)
# define GPIO_READ(g)		*(gpio.addr + 13) &= (1<<(g))

typedef struct				s_bcm2835_peripheral
{
    unsigned long			addr_p;
    int						mem_fd;
    void					*map;
    volatile unsigned int	*addr;
}							t_bcm2835_peripheral;

void	gpio_on(int pin);
void	gpio_off(int pin);
void	gpio_in(int pin);
void	gpio_out(int pin);
int		gpio_init(void);
int		map_peripheral(t_bcm2835_peripheral * p);
void	unmap_peripheral(t_bcm2835_peripheral * p);

//t_bcm2835_peripheral gpio = {GPIO_BASE, 0, 0, 0};
extern t_bcm2835_peripheral gpio;  // They have to be found somewhere, but can't be in the header

#endif
