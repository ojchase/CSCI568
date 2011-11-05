public class Axon
{
  private final Neuron source;
  private final Neuron target;
  private double weight;
  
  private Axon(Neuron source, Neuron target)
  {
    this.source = source;
    this.target = target;
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
  
  

}
