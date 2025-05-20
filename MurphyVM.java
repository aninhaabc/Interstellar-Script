public class MurphyVM {
  public static void main(String[] args) {
int signal = 12;
{
signal += 6;
System.out.println("Ajuste realizado no presente");
}
// bloco presente
{
for (int i = 0; i < 6; i++){
System.out.println("Mensagem vinda do futuro");
}
}
// bloco futuro
  }
}
