public class Axon
{
  private final HiddenNeuron source;
  private final HiddenNeuron target;
  private double weight;

  public Axon(HiddenNeuron source, HiddenNeuron target)
  {
    this.source = source;
    this.target = target;
    source.addTargetAxon(this);
    if(target != null)
      target.addSourceAxon(this);
    this.weight = Math.random() - Math.random(); // gives a range of -1 to +1
  }

  public HiddenNeuron getSource()
  {
    return source;
  }

  public HiddenNeuron getTarget()
  {
    return target;
  }

  public double getWeight()
  {
    return weight;
  }

  // this may or may not get used; I haven't decided how I want to update weights yet
  public void setWeight(double weight)
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
    target.receiveSignal(signal*weight);
  }

}
