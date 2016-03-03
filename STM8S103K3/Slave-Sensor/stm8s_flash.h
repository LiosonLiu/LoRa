/**
  ******************************************************************************
  * @file    stm8s_flash.h
  * @author  MCD Application Team
  * @version V2.1.0
  * @date    18-November-2011
  * @brief   This file contains all functions prototype and macros for the FLASH peripheral.
  ******************************************************************************
  * @attention
  *
  * THE PRESENT FIRMWARE WHICH IS FOR GUIDANCE ONLY AIMS AT PROVIDING CUSTOMERS
  * WITH CODING INFORMATION REGARDING THEIR PRODUCTS IN ORDER FOR THEM TO SAVE
  * TIME. AS A RESULT, STMICROELECTRONICS SHALL NOT BE HELD LIABLE FOR ANY
  * DIRECT, INDIRECT OR CONSEQUENTIAL DAMAGES WITH RESPECT TO ANY CLAIMS ARISING
  * FROM THE CONTENT OF SUCH FIRMWARE AND/OR THE USE MADE BY CUSTOMERS OF THE
  * CODING INFORMATION CONTAINED HEREIN IN CONNECTION WITH THEIR PRODUCTS.
  *
  * <h2><center>&copy; COPYRIGHT 2011 STMicroelectronics</center></h2>
  ******************************************************************************
  */
#include "STM8S103K3.h"
#include "stm8s_type.h"


/* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __STM8S_FLASH_H
#define __STM8S_FLASH_H

/* Includes ------------------------------------------------------------------*/
/*!< Signed integer types  */
typedef   signed char     int8_t;
typedef   signed short    int16_t;
typedef   signed long     int32_t;

/*!< Unsigned integer types  */
typedef unsigned char     uint8_t;
typedef unsigned short    uint16_t;
typedef unsigned long     uint32_t;

#define FAR  @far
#define NEAR @near
#define TINY @tiny
#define EEPROM @eeprom
#define CONST  const
#define PointerAttr NEAR

/** @addtogroup FLASH_Registers_Reset_Value
  * @{
  */
#define FLASH_CR1_RESET_VALUE   ((uint8_t)0x00)
#define FLASH_CR2_RESET_VALUE   ((uint8_t)0x00)
#define FLASH_NCR2_RESET_VALUE  ((uint8_t)0xFF)
#define FLASH_IAPSR_RESET_VALUE ((uint8_t)0x40)
#define FLASH_PUKR_RESET_VALUE  ((uint8_t)0x00)
#define FLASH_DUKR_RESET_VALUE  ((uint8_t)0x00)
/**
  * @}
  */

/** @addtogroup FLASH_Registers_Bits_Definition
  * @{
  */
#define FLASH_CR1_HALT        ((uint8_t)0x08) /*!< Standby in Halt mode mask */
#define FLASH_CR1_AHALT       ((uint8_t)0x04) /*!< Standby in Active Halt mode mask */
#define FLASH_CR1_IE          ((uint8_t)0x02) /*!< Flash Interrupt enable mask */
#define FLASH_CR1_FIX         ((uint8_t)0x01) /*!< Fix programming time mask */

#define FLASH_CR2_OPT         ((uint8_t)0x80) /*!< Select option byte mask */
#define FLASH_CR2_WPRG        ((uint8_t)0x40) /*!< Word Programming mask */
#define FLASH_CR2_ERASE       ((uint8_t)0x20) /*!< Erase block mask */
#define FLASH_CR2_FPRG        ((uint8_t)0x10) /*!< Fast programming mode mask */
#define FLASH_CR2_PRG         ((uint8_t)0x01) /*!< Program block mask */

#define FLASH_NCR2_NOPT       ((uint8_t)0x80) /*!< Select option byte mask */
#define FLASH_NCR2_NWPRG      ((uint8_t)0x40) /*!< Word Programming mask */
#define FLASH_NCR2_NERASE     ((uint8_t)0x20) /*!< Erase block mask */
#define FLASH_NCR2_NFPRG      ((uint8_t)0x10) /*!< Fast programming mode mask */
#define FLASH_NCR2_NPRG       ((uint8_t)0x01) /*!< Program block mask */

#define FLASH_IAPSR_HVOFF     ((uint8_t)0x40) /*!< End of high voltage flag mask */
#define FLASH_IAPSR_DUL       ((uint8_t)0x08) /*!< Data EEPROM unlocked flag mask */
#define FLASH_IAPSR_EOP       ((uint8_t)0x04) /*!< End of operation flag mask */
#define FLASH_IAPSR_PUL       ((uint8_t)0x02) /*!< Flash Program memory unlocked flag mask */
#define FLASH_IAPSR_WR_PG_DIS ((uint8_t)0x01) /*!< Write attempted to protected page mask */

#define FLASH_PUKR_PUK        ((uint8_t)0xFF) /*!< Flash Program memory unprotection mask */

#define FLASH_DUKR_DUK        ((uint8_t)0xFF) /*!< Data EEPROM unprotection mask */

/* Exported constants --------------------------------------------------------*/

#define FLASH_PROG_START_PHYSICAL_ADDRESS ((uint32_t)0x008000) /*!< Program memory: start address */

//#if defined (STM8S208) || defined(STM8S207) || defined(STM8S007) || defined (STM8AF52Ax) || defined (STM8AF62Ax)
// #define FLASH_PROG_END_PHYSICAL_ADDRESS   ((uint32_t)0x027FFF) /*!< Program memory: end address */
// #define FLASH_PROG_BLOCKS_NUMBER          ((uint16_t)1024)     /*!< Program memory: total number of blocks */
// #define FLASH_DATA_START_PHYSICAL_ADDRESS ((uint32_t)0x004000) /*!< Data EEPROM memory: start address */
// #define FLASH_DATA_END_PHYSICAL_ADDRESS   ((uint32_t)0x0047FF) /*!< Data EEPROM memory: end address */
// #define FLASH_DATA_BLOCKS_NUMBER          ((uint16_t)16)       /*!< Data EEPROM memory: total number of blocks */
// #define FLASH_BLOCK_SIZE                  ((uint8_t)128)       /*!< Number of bytes in a block (common for Program and Data memories) */
//#endif /* STM8S208, STM8S207, STM8S007, STM8AF52Ax, STM8AF62Ax */

//#if defined(STM8S105) || defined(STM8S005) || defined(STM8AF626x)
// #define FLASH_PROG_END_PHYSICAL_ADDRESS   ((uint32_t)0xFFFF)   /*!< Program memory: end address */
// #define FLASH_PROG_BLOCKS_NUMBER          ((uint16_t)256)      /*!< Program memory: total number of blocks */
//#define FLASH_DATA_START_PHYSICAL_ADDRESS ((uint32_t)0x004000) /*!< Data EEPROM memory: start address */
// #define FLASH_DATA_END_PHYSICAL_ADDRESS   ((uint32_t)0x0043FF) /*!< Data EEPROM memory: end address */
// #define FLASH_DATA_BLOCKS_NUMBER          ((uint16_t)8)        /*!< Data EEPROM memory: total number of blocks */
// #define FLASH_BLOCK_SIZE                  ((uint8_t)128)       /*!< Number of bytes in a block (common for Program and Data memories) */
//#endif /* STM8S105 or STM8AF626x */

//#if defined(STM8S103) || defined(STM8S003) ||  defined(STM8S903)
 #define FLASH_PROG_END_PHYSICAL_ADDRESS   ((uint32_t)0x9FFF)   /*!< Program memory: end address */
 #define FLASH_PROG_BLOCKS_NUMBER          ((uint16_t)128)      /*!< Program memory: total number of blocks */
 #define FLASH_DATA_START_PHYSICAL_ADDRESS ((uint32_t)0x004000) /*!< Data EEPROM memory: start address */
 #define FLASH_DATA_END_PHYSICAL_ADDRESS   ((uint32_t)0x00427F) /*!< Data EEPROM memory: end address */
 #define FLASH_DATA_BLOCKS_NUMBER          ((uint16_t)10)       /*!< Data EEPROM memory: total number of blocks */
 #define FLASH_BLOCK_SIZE                  ((uint8_t)64)        /*!< Number of bytes in a block (common for Program and Data memories) */
//#endif /* STM8S103, STM8S903 */

#define FLASH_RASS_KEY1 ((uint8_t)0x56) /*!< First RASS key */
#define FLASH_RASS_KEY2 ((uint8_t)0xAE) /*!< Second RASS key */

#define OPTION_BYTE_START_PHYSICAL_ADDRESS  ((uint16_t)0x4800)
#define OPTION_BYTE_END_PHYSICAL_ADDRESS    ((uint16_t)0x487F)
#define FLASH_OPTIONBYTE_ERROR              ((uint16_t)0x5555) /*!< Error code option byte 
                                                                   (if value read is not equal to complement value read) */
/**
  * @}
  */

/* Exported types ------------------------------------------------------------*/

/** @addtogroup FLASH_Exported_Types
  * @{
  */

/******************************************************************************
* @brief  FLASH Memory types
******************************************************************************/
#define 		FLASH_MEMTYPE_PROG 	0xFD 	/*!< Program memory */
#define 		FLASH_MEMTYPE_DATA 	0xF7  /*!< Data EEPROM memory */


/******************************************************************************
* @brief  FLASH programming modes
******************************************************************************/

#define 		FLASH_PROGRAMMODE_STANDARD 	0x00	/*!< Standard programming mode */
#define 		FLASH_PROGRAMMODE_FAST     	0x10  /*!< Fast programming mode */


/******************************************************************************
* @brief  FLASH fixed programming time
******************************************************************************/

#define 		FLASH_PROGRAMTIME_STANDARD 	0x00  /*!< Standard programming time fixed at 1/2 tprog */
#define 		FLASH_PROGRAMTIME_TPROG    	0x01  /*!< Programming time fixed at tprog */


/******************************************************************************
* @brief  FLASH Low Power mode select
******************************************************************************/

#define    	FLASH_LPMODE_POWERDOWN         	0x04 /*!< HALT: Power-Down / ACTIVE-HALT: Power-Down */
#define    	FLASH_LPMODE_STANDBY           	0x08 /*!< HALT: Standby    / ACTIVE-HALT: Standby */
#define    	FLASH_LPMODE_POWERDOWN_STANDBY 	0x00 /*!< HALT: Power-Down / ACTIVE-HALT: Standby */
#define    	FLASH_LPMODE_STANDBY_POWERDOWN 	0x0C /*!< HALT: Standby    / ACTIVE-HALT: Power-Down */

/******************************************************************************
* @brief  FLASH status of the last operation
******************************************************************************/
#if defined (STM8S208) || defined(STM8S207) || defined(STM8S007) || defined(STM8S105) || \
    defined(STM8S005) || defined (STM8AF52Ax) || defined (STM8AF62Ax) || defined(STM8AF626x)		
#define			FLASH_STATUS_END_HIGH_VOLTAGE           0x40 /*!< End of high voltage */
#endif /* STM8S208, STM8S207, STM8S105, STM8AF62Ax, STM8AF52Ax, STM8AF626x */
#define			FLASH_STATUS_SUCCESSFUL_OPERATION       0x04 /*!< End of operation flag */
#define			FLASH_STATUS_TIMEOUT 										0x02 /*!< Time out error */
#define   	FLASH_STATUS_WRITE_PROTECTION_ERROR    	0x01 /*!< Write attempted to protected page */

/******************************************************************************
* @brief  FLASH flags definition
* - Warning : FLAG value = mapping position register
******************************************************************************/

#if defined (STM8S208) || defined(STM8S207) || defined(STM8S007) || defined(STM8S105) || \
    defined(STM8S005) || defined (STM8AF52Ax) || defined (STM8AF62Ax) || defined(STM8AF626x)
#define    	FLASH_FLAG_HVOFF     			0x40     /*!< End of high voltage flag */
#endif /* STM8S208, STM8S207, STM8S105, STM8AF62Ax, STM8AF52Ax, STM8AF626x */
#define    	FLASH_FLAG_DUL      		 	0x08     /*!< Data EEPROM unlocked flag */
#define 		FLASH_FLAG_EOP       			0x04     /*!< End of programming (write or erase operation) flag */
#define    	FLASH_FLAG_PUL       			0x02     /*!< Flash Program memory unlocked flag */
#define    	FLASH_FLAG_WR_PG_DIS 			0x01     /*!< Write attempted to protected page flag */

/**
  * @}
  */

/* Private macros ------------------------------------------------------------*/

/**
  * @brief  Macros used by the assert function in order to check the different functions parameters.
  * @addtogroup FLASH_Private_Macros
  * @{
  */

/**
  * @brief  Macro used by the assert function in order to check the different sensitivity values for the flash program Address
  */

/*#define IS_FLASH_PROG_ADDRESS_OK(ADDRESS) (((ADDRESS) >= FLASH_PROG_START_PHYSICAL_ADDRESS) && \
    ((ADDRESS) <= FLASH_PROG_END_PHYSICAL_ADDRESS))*/

/**
  * @brief  Macro used by the assert function in order to check the different sensitivity values for the data eeprom Address
  */

#define IS_FLASH_DATA_ADDRESS_OK(ADDRESS) (((ADDRESS) >= FLASH_DATA_START_PHYSICAL_ADDRESS) && \
    ((ADDRESS) <= FLASH_DATA_END_PHYSICAL_ADDRESS))

/**
  * @brief  Macro used by the assert function in order to check the different sensitivity values for the data eeprom and flash program Address
  */
#define IS_FLASH_ADDRESS_OK(ADDRESS)((((ADDRESS) >= FLASH_PROG_START_PHYSICAL_ADDRESS) && ((ADDRESS) <= FLASH_PROG_END_PHYSICAL_ADDRESS)) || \
                                     (((ADDRESS) >= FLASH_DATA_START_PHYSICAL_ADDRESS) && ((ADDRESS) <= FLASH_DATA_END_PHYSICAL_ADDRESS)))

/**
  * @brief  Macro used by the assert function in order to check the different sensitivity values for the flash program Block number
  */
#define IS_FLASH_PROG_BLOCK_NUMBER_OK(BLOCKNUM) ((BLOCKNUM) < FLASH_PROG_BLOCKS_NUMBER)

/**
  * @brief  Macro used by the assert function in order to check the different sensitivity values for the data eeprom Block number
  */
#define IS_FLASH_DATA_BLOCK_NUMBER_OK(BLOCKNUM) ((BLOCKNUM) < FLASH_DATA_BLOCKS_NUMBER)

/**
  * @brief  Macro used by the assert function in order to check the different sensitivity values for the flash memory type
  */

#define IS_MEMORY_TYPE_OK(MEMTYPE) (((MEMTYPE) == FLASH_MEMTYPE_PROG) || ((MEMTYPE) == FLASH_MEMTYPE_DATA))

/**
  * @brief  Macro used by the assert function in order to check the different sensitivity values for the flash program mode
  */

#define IS_FLASH_PROGRAM_MODE_OK(MODE) (((MODE) == FLASH_PROGRAMMODE_STANDARD) || ((MODE) == FLASH_PROGRAMMODE_FAST))

/**
  * @brief  Macro used by the assert function in order to check the program time mode
  */

#define IS_FLASH_PROGRAM_TIME_OK(TIME) (((TIME) == FLASH_PROGRAMTIME_STANDARD) || ((TIME) == FLASH_PROGRAMTIME_TPROG))

/**
  * @brief  Macro used by the assert function in order to check the different 
  *         sensitivity values for the low power mode
  */

#define IS_FLASH_LOW_POWER_MODE_OK(LPMODE) (((LPMODE) == FLASH_LPMODE_POWERDOWN) ||((LPMODE) == FLASH_LPMODE_STANDBY) || ((LPMODE) == FLASH_LPMODE_POWERDOWN_STANDBY) || ((LPMODE) == FLASH_LPMODE_STANDBY_POWERDOWN))

/**
  * @brief  Macro used by the assert function in order to check the different 
  *         sensitivity values for the option bytes Address
  */
#define IS_OPTION_BYTE_ADDRESS_OK(ADDRESS) (((ADDRESS) >= OPTION_BYTE_START_PHYSICAL_ADDRESS) && \
    ((ADDRESS) <= OPTION_BYTE_END_PHYSICAL_ADDRESS))


/**
  * @brief  Macro used by the assert function in order to check the different flags values
  */
#if defined (STM8S208) || defined(STM8S207) || defined(STM8S007) || defined(STM8S105) || \
    defined(STM8S005) || defined (STM8AF52Ax) || defined (STM8AF62Ax) || defined(STM8AF626x)
 #define IS_FLASH_FLAGS_OK(FLAG) (((FLAG) == FLASH_FLAG_HVOFF) || \
                                 ((FLAG) == FLASH_FLAG_DUL) || \
                                 ((FLAG) == FLASH_FLAG_EOP) || \
                                 ((FLAG) == FLASH_FLAG_PUL) || \
                                 ((FLAG) == FLASH_FLAG_WR_PG_DIS))
#else /* STM8S103, STM8S903 */
 #define IS_FLASH_FLAGS_OK(FLAG) (((FLAG) == FLASH_FLAG_DUL) || \
                                 ((FLAG) == FLASH_FLAG_EOP) || \
                                 ((FLAG) == FLASH_FLAG_PUL) || \
                                 ((FLAG) == FLASH_FLAG_WR_PG_DIS))
#endif /* STM8S208, STM8S207, STM8S105, STM8AF62Ax, STM8AF52Ax, STM8AF626x */
/**
  * @}
  */

/* Exported functions ------------------------------------------------------- */

/** @addtogroup FLASH_Exported_Functions
  * @{
  */
	
//unsigned char IS_MEMORY_TYPE_OK(unsigned char MEMTYPE);
//unsigned char IS_FLASH_ADDRESS_OK(uint32_t ADDRESS);

void FLASH_Unlock(uint8_t FLASH_MemType);
void FLASH_Lock(uint8_t FLASH_MemType);
void FLASH_DeInit(void);
//void FLASH_ITConfig(uint8_t NewState);
//void FLASH_EraseByte(uint32_t Address);
void FLASH_ProgramByte(uint32_t Address, uint8_t Data);
uint8_t FLASH_ReadByte(uint32_t Address);
//void FLASH_ProgramWord(uint32_t Address, uint32_t Data);
//uint16_t FLASH_ReadOptionByte(uint16_t Address);
//void FLASH_ProgramOptionByte(uint16_t Address, uint8_t Data);
//void FLASH_EraseOptionByte(uint16_t Address);
//void FLASH_SetLowPowerMode(uint8_t FLASH_LPMode);
//void FLASH_SetProgrammingTime(FLASH_ProgramTime_TypeDef FLASH_ProgTime);
//uint8_t FLASH_GetLowPowerMode(void);
//uint8_t FLASH_GetProgrammingTime(void);
//uint32_t FLASH_GetBootSize(void);
//uint8_t FLASH_GetFlagStatus(uint8_t FLASH_FLAG);

/**
@code
 All the functions declared below must be executed from RAM exclusively, except 
 for the FLASH_WaitForLastOperation function which can be executed from Flash.
 
 Steps of the execution from RAM differs from one toolchain to another.
 for more details refer to stm8s_flash.c file.
 
 To enable execution from RAM you can either uncomment the following define 
 in the stm8s.h file or define it in your toolchain compiler preprocessor
 - #define RAM_EXECUTION  (1) 

@endcode
*/
//IN_RAM(void FLASH_EraseBlock(uint16_t BlockNum, uint8_t FLASH_MemType));
//IN_RAM(void FLASH_ProgramBlock(uint16_t BlockNum, uint8_t FLASH_MemType, uint8_t FLASH_ProgMode, uint8_t *Buffer));
//IN_RAM(uint8_t FLASH_WaitForLastOperation(uint8_t FLASH_MemType));

/**
  * @}
  */

#endif /*__STM8S_FLASH_H */

/******************* (C) COPYRIGHT 2011 STMicroelectronics *****END OF FILE****/
