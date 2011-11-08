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
    this.weight = Math.random() - Math.random(); // gives a range of -1 to +1
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
  
  public void sendSignal(double signal)
  {
    if(target == null)
    {
      System.out.println(source + " output value: " + (signal * weight));
      return;
    }
    target.receiveSignal(signal*weight);
  }

}
