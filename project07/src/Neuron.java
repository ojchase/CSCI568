import java.util.ArrayList;
import java.util.List;

public class Neuron
{
  // The neuron shouldn't actually need to know who it's connected to.
  // It just sends signals up and down axons to whoever is listening.
  private List<Axon> sourceAxons = new ArrayList<Axon>(); // These send signals to the neuron
  private List<Axon> targetAxons = new ArrayList<Axon>(); // This neuron sends its signals via these axons
  private final double threshold = 0; // arbitrarily set
  private double accumulatedSignal = 0; // Total signal received so far from its source neurons
  private final String id;
  
  public Neuron(String id)
  {
    this.id = id;
  }
  
  public List<Neuron> fire()
  {
    List<Neuron> affectedNeurons = new ArrayList<Neuron>();
    for(Axon axon : targetAxons)
    {
      if(accumulatedSignal >= threshold)
        axon.sendSignal(true);
      else
        axon.sendSignal(false);
      Neuron axonTarget = axon.getTarget();
      if(axonTarget != null)
        affectedNeurons.add(axonTarget);
    }
    return affectedNeurons;
  }
  
  public void receiveSignal(double signalStrength)
  {
    accumulatedSignal += signalStrength;
  }

  public void addSourceAxon(Axon axon)
  {
    sourceAxons.add(axon);
  }

  public void addTargetAxon(Axon axon)
  {
    targetAxons.add(axon);
  }
  
  public String toString()
  {
    return id;
  }
}
