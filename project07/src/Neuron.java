import java.util.List;

public class Neuron
{
  // The neuron shouldn't actually need to know who it's connected to.
  // It just sends signals up and down axons to whoever is listening.
  private List<Axon> sourceAxons; // These send signals to the neuron
  private List<Axon> targetAxons; // This neuron sends its signals via these axons
  private final double threshold;
  private double accumulatedSignal = 0; // Total signal received so far from its source neurons
  private boolean fired = false; // We don't want a neuron to fire twice
  
  public Neuron(double threshold)
  {
    this.threshold = threshold;
  }
  
  private void fire()
  {
    for(Axon axon : targetAxons)
    {
      axon.sendSignal();
    }
  }
  
  public void receiveSignal(double signalStrength)
  {
    accumulatedSignal += signalStrength;
    if(accumulatedSignal >= threshold && !fired)
      fire();
  }
}
