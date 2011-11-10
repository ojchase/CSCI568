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
    //this.weight = Math.random() - Math.random(); // gives a range of -1 to +1
    this.weight = 0.5; // gives a range of -1 to +1
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

  public void setWeight(double weight)
  {
    this.weight = weight;
  }
  
  public void sendSignal(double signal)
  {
    Network.debug("    Axon receiving value: " + signal);
    Network.debug("    Weight: " + weight);
    Network.debug("    " + source + "->" + target + " sending " + signal*weight);
    target.receiveSignal(signal*weight);
  }

}
