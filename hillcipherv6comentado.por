programa
{
	inclua biblioteca Texto
	inclua biblioteca Util
	inclua biblioteca Matematica
	inclua biblioteca Tipos

	//Define o maior tamanho possível da mensagem
	const inteiro LENGTH = 500

	//Define o conjunto de caracteres disponível para a chave e a mensagem
	cadeia charset = "zabcdefghijklmnopqrstuvwxy "

	//Define o tamanho do número de caracteres
	//O Zm em questão é definido pelo número de caracteres
	//disponíveis para a chave e a mensagem.
	//Assim, para o alfabeto simples (de 'a' a 'z'),
	//o Zm é Z26, enquanto que para o alfabeto simples
	//mais o espaço (' '), O Zm é Z27
	inteiro char_size = Texto.numero_caracteres(charset)

	//Chave na forma de string (cadeia)
	cadeia key_string

	//Chave na forma de array (lista)
	caracter key[4]

	//Mensagem na forma de string (cadeia)
	cadeia message_string

	//Mensagem na forma de array (lista)
	caracter message[LENGTH]

	//O inverso multiplicativo modular
	inteiro inverted_determinant = -1

	//Chave na forma matricial
	inteiro key_matrix[2][2]

	//Tamanho da mensagem inserida pelo usuário
	inteiro message_length

	//Número de colunas da matriz da mensagem
	inteiro column

	//Mensagem na forma matricial
	inteiro message_matrix[2][LENGTH]

	//Escolha do usuário (criptografia ou descriptografia)
	caracter user_choice
	
	funcao inicio()
	{
		//Explica o propósito do programa e orienta o usuário
		escreva("Este é um programa que codifica e decodifica mensagens com a cifra de Hill, usando uma matriz 2x2.\n")
		escreva("Escolha uma chave (palavra com 4 letras minúsculas, sem acento):\n")
		escreva("Chave: ")

		//Recebe a chave do usuário e a converte em uma lista de caracteres
		leia(key_string)
		string_to_array(key_string, key)

		//Verifica se existe uma matriz inversa para aquela chave
		//Determina se aquela chave pode ser empregada para a cifra de Hill
		verify()

		//O valor padrão para "inverted_determinant" é 0
		//se ele continuar 0 isso significa que não existe
		//matriz inversa para a chave e que, portanto, ela
		//não pode ser empregada para a criptografia
		se (inverted_determinant != -1) {
			
			//Orienta o usuário a inserir a mensagem
			escreva("Escreva a mensagem (apenas letras minúsculas, sem acento): ")
			
			//Recebe a mensagem do usuário e a converte em uma lista de caracteres
			leia(message_string)
			string_to_array(message_string, message)

			//Transforma a chave em uma matriz numérica
			//Caracteres são transformados em números
			//de acordo com o index que ocupam na charset
			key_matrix[0][0] = char_to_int(key[0])
			key_matrix[0][1] = char_to_int(key[1])
			key_matrix[1][0] = char_to_int(key[2])
			key_matrix[1][1] = char_to_int(key[3])

			//Encontra o tamanho da mensagem
			message_length = Texto.numero_caracteres(message_string)

			//Determina quantas colunas da message_matrix
			//devem ser usadas para armazenar a mensagem
			//A expressão busca incluir mensagens de tamanho
			//ímpar
			column = message_length / 2 + message_length % 2

			//Preenche a primeira linha da matriz
			//Converte caracteres em números
			inteiro i
			para (i = 0; i < column; i++) {
				message_matrix[0][i] = char_to_int(message[i])
			}

			//Preenche a segunda linha da matriz
			//Começa o preenchimento dela
			//do ponto onde parou na array message
			//Insere um "X" quando sobra espaço
			para (i = 0; i < column; i++) {
				
				se (i + column >= message_length) {
					message_matrix[1][i] = char_to_int('x')
				} senao {
          message_matrix[1][i] = char_to_int(message[i + column])
        }
			}

			//Pede para o usuário decidir o que fazer
			escreva("Codificar ou Decodificar? (C ou D) ")
			leia(user_choice)

			se (user_choice == 'c' ou user_choice == 'C') {
				encrypt()
			}
			se (user_choice == 'd' ou user_choice == 'D') {
				decrypt()
			}
		} senao {
			//Informa ao usuário que a chave é inválida
			escreva("Chave Inválida")
		}
	}

	//Converte uma cadeia em uma lista
	funcao vazio string_to_array(cadeia string, caracter caracteres[])
	{
		inteiro string_size = Texto.numero_caracteres(string)
		para (inteiro i = 0; i < string_size; i++) {
			caracteres[i] = Texto.obter_caracter(string, i)
		}
	}

	//Procura pelo caractere na cadeia charset
	//e devolve o index no qual ele se encontra
	funcao inteiro char_to_int(caracter character)
	{
		para (inteiro i = 0; i < char_size; i++) {
			se (Texto.obter_caracter(charset, i) == character) {
				retorne i
			}
		}
		retorne -1
	}

	//Devolve um caractere de acordo com o seu index
	//Nesse programa, só recebe index positivos
	funcao caracter int_to_char(inteiro integer) {
		retorne Texto.obter_caracter(charset, integer % char_size)
	}

	//Devolve o valor absoluto de um inteiro
	funcao inteiro absval(inteiro integer) {
		se (integer > 0) {
			retorne integer
		}
		se (integer < 0) {
			retorne integer * -1
		}
		retorne 0
	}

	//Calcula o determinante inverso modular
	//Caso não consigue encontrá-lo,
	//"inverted_determinant" se torna -1
	//Indicando que ele não existe
	funcao vazio verify()
	{
		inteiro determinant = 0

		//Cálculo do determinante
		determinant += char_to_int(key[0]) * char_to_int(key[3])
		determinant -= char_to_int(key[1]) * char_to_int(key[2])

		//Encontra-se o equivalente do determinante módulo char_size
		inteiro R
		R = absval(determinant) % char_size

		se (determinant >= 0) {
			determinant = R
		}

		se (determinant < 0) {
			se (absval(determinant) % char_size != 0) {
				determinant = char_size - R
			}
			se (absval(determinant) % char_size == 0) {
				determinant = 0
			}
		}

		inverted_determinant = -1

		//Encontra-se o inverso multipicativo do determinante
		//módulo char_size
		inteiro i
		para (i = 0; i < char_size; i++) {
			se (absval(determinant * i) % char_size == 1) {
				inverted_determinant = i
			}
		}
	}

	//Criptografa a mensagem
	//Multiplica a matriz chave pela matriz mensagem
	funcao vazio encrypt() {
		inteiro i, j, k, accumulator = 0
		para (i = 0; i < 2; i++) {
			para (j = 0; j < column; j++) {
				para (k = 0; k < 2; k++) {
					accumulator += key_matrix[i][k] * message_matrix[k][j]
				}
				escreva(int_to_char(accumulator))
				accumulator = 0
			}
		}
	}

	//Descriptografa a mensagem
	//Calcula a matriz inversa da chave
	//Multiplica ela pela matriz mensagem
	funcao vazio decrypt() {
		inteiro inverted_key_matrix[2][2]

		inverted_key_matrix[0][0] = key_matrix[1][1] * inverted_determinant
		inverted_key_matrix[0][1] = key_matrix[0][1] * -1 * inverted_determinant
		inverted_key_matrix[1][0] = key_matrix[1][0] * -1 * inverted_determinant
		inverted_key_matrix[1][1] = key_matrix[0][0] * inverted_determinant

		inteiro i, j, R

		//Depois de os elementos da matriz inversa
		//terem sido multiplicados pelo inverso multiplicativo
		//do determinante módulo charset, eles são substituídos
		//pelos equivalentes deles módulo charset
		para (i = 0; i < 2; i++) {
			para (j = 0; j < 2; j++) {
				R = absval(inverted_key_matrix[i][j]) % char_size
				se (inverted_key_matrix[i][j] >= 0) {
					inverted_key_matrix[i][j] = R
				}
				se (inverted_key_matrix[i][j] < 0) {
					se (R != 0) {
						inverted_key_matrix[i][j] = char_size - R
					}
					se (R == 0) {
						inverted_key_matrix[i][j] = 0
					}
				}
			}
		}
		inteiro k, accumulator = 0
		para (i = 0; i < 2; i++) {
			para (j = 0; j < column; j++) {
				para (k = 0; k < 2; k++) {
					accumulator += inverted_key_matrix[i][k] * message_matrix[k][j]
				}
				escreva(int_to_char(accumulator))
				accumulator = 0
			}
		}
	}
}
/* $$$ Portugol Studio $$$ 
 * 
 * Esta seção do arquivo guarda informações do Portugol Studio.
 * Você pode apagá-la se estiver utilizando outro editor.
 * 
 * @POSICAO-CURSOR = 6565; 
 * @PONTOS-DE-PARADA = ;
 * @SIMBOLOS-INSPECIONADOS = ;
 * @FILTRO-ARVORE-TIPOS-DE-DADO = inteiro, real, logico, cadeia, caracter, vazio;
 * @FILTRO-ARVORE-TIPOS-DE-SIMBOLO = variavel, vetor, matriz, funcao;
 */
