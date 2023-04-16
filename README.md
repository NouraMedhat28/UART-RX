# UART-RX
#### The repository has my design and implementation of a UART receiver. Receiving UART will  convert the serial data back into parallel data for the receiving device.
### Block Interface:-
![Screenshot (20)](https://user-images.githubusercontent.com/96621514/232343327-8392365a-f754-40bf-bf1d-aa5703dfa63f.jpg)

### Specifications
~ UART TX receive a UART frame on S_DATA.
</br>
~ UART_RX support oversampling by 8
</br>
~ S_DATA is high in the IDLE case (No transmission).
</br>
~ PAR_ERR signal is high when the calculated parity bit not equal the received frame parity bit as this mean that the frame is corrupted.
</br>
~ STP_ERR signal is high when the received stop bit not equal 1 as this mean that the frame is corrupted.
</br>
~ DATA is extracted from the received frame and then sent through P_DATA bus associated with DATA_VLD signal only after checking that the frame is received correctly and not corrupted.
(PAR_ERR = 0 && STP_ERR = 0).
</br>
~ UART_RX can accept consequent frames.
</br>
~ Registers are cleared using asynchronous active low reset
</br>
~ PAR_EN (Configuration)
</br>
0: To disable frame parity bit
</br>
1: To enable frame parity bit
</br>
~ PAR_TYP (Configuration)
</br>
0: Even parity bit
</br>
1: Odd parity bit
### Simulation on Modelsim
![Screenshot (22)](https://user-images.githubusercontent.com/96621514/232344347-7e04fc66-c0f6-4c44-b3e3-ef30ec163660.png)
