/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   RPI.h                                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: pciavald <pciavald@student.42.fr>          +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2015/05/14 18:38:50 by pciavald          #+#    #+#             */
/*   Updated: 2015/05/14 19:02:27 by pciavald         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef RPI_H
# define RPI_H
# include <stdio.h>
# include <sys/mman.h>
# include <sys/types.h>
# include <sys/stat.h>
# include <unistd.h>

# define BCM2708_PERI_BASE		0x20000000
# define GPIO_BASE				(BCM2708_PERI_BASE + 0x200000)
# define BLOCK_SIZE				(4*1024)

typedef struct					s_bcm2835_peripheral
{
    unsigned long				addr_p;
    int							mem_fd;
    void						*map;
    volatile unsigned int		*addr;
}								t_bcm2835_peripheral;

//t_bcm2835_peripheral gpio = {GPIO_BASE, 0, 0, 0};
extern t_bcm2835_peripheral gpio;  // They have to be found somewhere, but can't be in the header

#endif
