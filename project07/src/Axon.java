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

  // this may or may not get used; I haven't decided how I want to update weights yet
  private void setWeight(double weight)
  {
    this.weight = weight;
  }

  // this may or may not get used; I haven't decided how I want to update weights yet
  private void addWeight(double weight)
  {
    this.weight += weight;
  }

  // this may or may not get used; I haven't decided how I want to update weights yet
  private void multiplyWeight(double weight)
  {
    this.weight *= weight;
  }
  
  public void sendSignal()
  {
    target.receiveSignal(weight);
  }

}
