# AVR microcontroller lab 8

## Task

1. Два набори LED-ів згідно натиску відповідної кнопки відпрацьовують вказані алгоритми і гаснуть. При цьому алгоритми можуть працювати незалежно один від одного. Натиск відповідної кнопки перезапускає вказаний алгоритм, який зараз працює, спочатку.
2. Часові інтервали вимірюються за допомогою таймерів, при цьому паралельно виконується робота в основній програмі.
3. При натиску кнопок звучить сигнал бузера.
4. Програма має бути написана мовою Асемблер.

| Кнопки   | Світлодіоди    | Затримка  | Таймер | Алгоритми |
| -------- | -------------- | --------- | ------ | --------- |
| PA0, PA2 | port-K, port-F | 1,05 сек. | T3     | 6, 1      |

### Опис алгоритму

**Алгоритм 1**  
Лінійка з 8-ми одноколірних світлодіодів. При натисканні кнопки світлодіоди почергово блимають від 0-виводу порту до 7.  
**P0**→P1→P2→P3→P4→P5→P6→P7

**Алгоритм 6**  
Лінійка з 8-ми одноколірних світлодіодів. При натисканні кнопки світлодіоди починають почергово блимати через один від 7-виводу порту до 1, а потім далі від 6 до 0.  
P0←P2←P4←P6←P1←P3←P5←**P7**

## Getting Started

### Prerequisites

- Install [Microchip Studio](https://www.microchip.com/en-us/development-tools-tools-and-software/microchip-studio-for-avr-and-sam-devices)
- Install [Proteus](https://www.labcenter.com/)

### Installing

- Clone repository into your system

```
git clone https://github.com/Ravenen/microcontroller_lab_8.git
```

### Executing program

- Build a project in `code` folder via Microchip builder
- Open Proteus project and run the simulation

## Authors

[Vitaliy Pavliyk (@ravenen)](https://github.com/Ravenen)
