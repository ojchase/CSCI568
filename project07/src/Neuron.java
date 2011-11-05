import java.util.ArrayList;
import java.util.List;

public class Neuron
{
  // The neuron shouldn't actually need to know who it's connected to.
  // It just sends signals up and down axons to whoever is listening.
  private List<Axon> sourceAxons = new ArrayList<Axon>(); // These send signals to the neuron
  private List<Axon> targetAxons = new ArrayList<Axon>(); // This neuron sends its signals via these axons
  private final double threshold = 1; // arbitrarily set
  private double accumulatedSignal = 0; // Total signal received so far from its source neurons
  
  public Neuron()
  {
    
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
      affectedNeurons.add(axon.getTarget());
    }
    if(affectedNeurons.size() == 0) // output neuron
    {
      for(Axon axon : targetAxons)
      {
        System.out.println("Output value: " + axon.getWeight());
      }
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
}
