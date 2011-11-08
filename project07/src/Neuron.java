import java.util.ArrayList;
import java.util.List;

public class Neuron
{
  // The neuron shouldn't actually need to know who it's connected to.
  // It just sends signals up and down axons to whoever is listening.
  protected List<Axon> sourceAxons = new ArrayList<Axon>(); // These send signals to the neuron
  private List<Axon> targetAxons = new ArrayList<Axon>(); // This neuron sends its signals via these axons
  protected double accumulatedSignal = 0; // Total signal received so far from its source neurons
  protected final String id;
  private double error = 0;
  protected double outputValue = 0;
  
  public Neuron(String id)
  {
    this.id = id;
  }
  
  public List<? extends Neuron> fire()
  {
    outputValue = calculateOutput(accumulatedSignal);
    
    List<Neuron> affectedNeurons = new ArrayList<Neuron>();
    for(Axon axon : targetAxons)
    {
      axon.sendSignal(outputValue);
      Neuron axonTarget = axon.getTarget();
      if(axonTarget != null)
        affectedNeurons.add(axonTarget);
    }
    return affectedNeurons;
  }
  
  protected double calculateOutput(double accumulatedSignal)
  {
    return 1.0 / (1 + Math.pow(Math.E, accumulatedSignal));
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
