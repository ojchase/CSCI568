public class Axon
{
  private final Neuron source;
  private final Neuron target;
  private double weight;

  public Axon(Neuron source, Neuron target)
  {
    this.source = source;
    this.target = target;
    source.addTargetAxon(this);
    if(target != null)
      target.addSourceAxon(this);
    this.weight = .15;//Math.random() - Math.random(); // gives a range of -1 to +1
  }

  public Neuron getSource()
  {
    return source;
  }

  public Neuron getTarget()
  {
    return target;
  }

  public double getWeight()
  {
    return weight;
  }

  // this may or may not get used; I haven't decided how I want to update weights yet
  private void setWeight(double weight)
  {
    this.weight = weight;
  }

  // this may or may not get used; I haven't decided how I want to update weights yet
  private void addWeight(double weight)
  {
    this.weight += weight;
    if(this.weight > 1)
      this.weight = 1;
    if(this.weight < -1)
      this.weight = -1;
  }
  
  /**
   * Sends either a full or empty signal to the target neuron.
   * A signal gets "sent" either way, but it will be a 0 signal if sendSignal is false.
   * @param amountOfSignal
   */
  public void sendSignal(boolean sendSignal)
  {
    if(target == null)
    {
      System.out.println("Output value: " + (sendSignal ? weight : 0));
      return;
    }
    if(sendSignal)
      target.receiveSignal(weight);
    else
      target.receiveSignal(0);
  }

}
