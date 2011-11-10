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

  @Deprecated
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
  
  /*public double adjustWeight()
  {
    Network.debug("  Evaluating axon to " + source);
    Network.debug("    Old weight: " + weight);
    Network.debug("    Error caused by this axon's weight: " + target.overallErrorCausedByWeight(this)); // TODO bad design/
    double adjustment = -0.5 * target.overallErrorCausedByWeight(this);
    Network.debug("    Adjusting by " + adjustment);
    Network.debug("    New weight: " + weight);
    return weight + adjustment;
  }  */
  public void adjustWeight()
  {
    Network.debug("  Evaluating axon to " + source);
    Network.debug("    Old weight: " + weight);
    Network.debug("    Error caused by this axon's weight: " + target.overallErrorCausedByWeight(this)); // TODO bad design/
    double adjustment = -0.5 * target.overallErrorCausedByWeight(this);
    Network.debug("    Adjusting by " + adjustment);
    weight += adjustment;
    Network.debug("    New weight: " + weight);
  }

}
