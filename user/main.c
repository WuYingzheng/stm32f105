/*
	CAN1
	USART1

    CAN�����ʡ��շ��� ���ü�CAN.h
	stm32f10x.h���޸����ⲿ����ֵ8MHz
*/

/* Includes ------------------------------------------------------------------*/

#include "stm32f10x_conf.h"
#include "stm32f10x.h"
#include "stm32f10x_rcc.h"
#include "stm32f10x_flash.h"
#include <stdio.h>

void RCC_Configuration(void);
void LED_Config(void);
void Delay(__IO uint32_t nCount);

struct people{
	char name;
	char age;
	char sex;
	union{
		char byte;
		uint8_t num;
	}bye;
};

int l;

int main(void)
{
	struct people andy;


  /* System Clocks Configuration **********************************************/
  RCC_Configuration();   
  LED_Config();

  Delay(2000);
                               			  
  // CAN2 ����
  	  			
						  
  while (1)
  {     
	andy.name++;
	andy.age++;
	l++;

	GPIO_ResetBits(GPIOC,GPIO_Pin_0);
	  GPIO_SetBits(GPIOC,GPIO_Pin_1);
	  GPIO_SetBits(GPIOC,GPIO_Pin_14);
	  GPIO_SetBits(GPIOC,GPIO_Pin_15);
     
	  Delay(5000);
	  Delay(5000);	  
	  
	  GPIO_SetBits(GPIOC,GPIO_Pin_0); 
	  GPIO_ResetBits(GPIOC,GPIO_Pin_1);
	  GPIO_SetBits(GPIOC,GPIO_Pin_14);
	  GPIO_SetBits(GPIOC,GPIO_Pin_15);


	  Delay(5000);
	  Delay(5000);

	  GPIO_SetBits(GPIOC,GPIO_Pin_0); 
	  GPIO_SetBits(GPIOC,GPIO_Pin_1);
	  GPIO_ResetBits(GPIOC,GPIO_Pin_14);
	  GPIO_SetBits(GPIOC,GPIO_Pin_15);
	  
	  Delay(5000);
	  Delay(5000);	  
	  
	  GPIO_SetBits(GPIOC,GPIO_Pin_0); 
	  GPIO_SetBits(GPIOC,GPIO_Pin_1);
	  GPIO_SetBits(GPIOC,GPIO_Pin_14);
	  GPIO_ResetBits(GPIOC,GPIO_Pin_15);
	 
	  Delay(5000);
	  Delay(5000);											

  }
}


void RCC_Configuration(void)
{   
  /* Setup the microcontroller system. Initialize the Embedded Flash Interface,  
     initialize the PLL and update the SystemFrequency variable. */
  SystemInit();
								  			 
}


void Delay(__IO uint32_t nCount)
{
    uint32_t x;
	int l;
    for(; nCount != 0; nCount--)
	    for(x=0;x<600;x++)
		  l++;
}

void LED_Config(void)
{
  GPIO_InitTypeDef GPIO_InitStructure;

  RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOC, ENABLE);
  
  GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0|GPIO_Pin_1|GPIO_Pin_14|GPIO_Pin_15;				   
  GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
  GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
  GPIO_Init(GPIOC, &GPIO_InitStructure);					 
}


#ifdef  USE_FULL_ASSERT

/**
  * @brief  Reports the name of the source file and the source line number
  *   where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t* file, uint32_t line)
{
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */
  /* Infinite loop */
  while (1)
  {
  }
}
#endif



/******************* (C) COPYRIGHT 2009 STMicroelectronics *****END OF FILE****/
