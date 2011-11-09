import java.util.ArrayList;
import java.util.List;

public class HiddenNeuron
{
  // The neuron shouldn't actually need to know who it's connected to.
  // It just sends signals up and down axons to whoever is listening.
  protected List<Axon> sourceAxons = new ArrayList<Axon>(); // These send signals to the neuron
  private List<Axon> targetAxons = new ArrayList<Axon>(); // This neuron sends its signals via these axons
  protected double accumulatedSignal = 0; // Total signal received so far from its source neurons
  protected final String id;
  protected double outputErrorGradient = -1;
  protected double outputValue = 0;
  
  public HiddenNeuron(String id)
  {
    this.id = id;
  }
  
  public final void receiveSignal(double signalStrength)
  {
    accumulatedSignal += signalStrength;
  }

  public final void addSourceAxon(Axon axon)
  {
    sourceAxons.add(axon);
  }

  public final void addTargetAxon(Axon axon)
  {
    targetAxons.add(axon);
  }
  
  public double getOutputValue()
  {
    return outputValue;
  }

  public List<? extends HiddenNeuron> fire()
  {
    outputValue = calculateOutput(accumulatedSignal);
    
    List<HiddenNeuron> affectedNeurons = new ArrayList<HiddenNeuron>();
    for(Axon axon : targetAxons)
    {
      axon.sendSignal(outputValue);
      HiddenNeuron axonTarget = axon.getTarget();
      if(axonTarget != null)
        affectedNeurons.add(axonTarget);
    }
    return affectedNeurons;
  }
  
  protected final double calculateOutput(double accumulatedSignal)
  {
    return 1.0 / (1 + Math.pow(Math.E, -1*accumulatedSignal));
  }
  
  public final String toString()
  {
    return id;
  }
  
  public double getOutputErrorGradient()
  {
    if(outputErrorGradient < 0)
      outputErrorGradient = calculateOutputErrorGradient();
    return outputErrorGradient;
  }

  /**
   * Calculates the error gradient with respect to the neuron's output (e.g. dE/dx)
   * @return
   */
  private double calculateOutputErrorGradient()
  {
    double result = 0;
    for(Axon a : targetAxons)
    {
      result += (a.getTarget().getOutputErrorGradient() * errorCausedToTarget(a));
    }
    return result;
  }

  /**
   * Returns the amount of error that the value of this neuron causes to a target neuron
   * e.g. dy_j/dx_i
   * @param a
   * @return
   */
  private double errorCausedToTarget(Axon a)
  {
    HiddenNeuron target = a.getTarget();
    double targetOutput = target.getOutputValue();
    return targetOutput * (1 - targetOutput) * a.getWeight();
  }

  public final List<? extends HiddenNeuron> backPropogate()
  {
    List<HiddenNeuron> affectedNeurons = new ArrayList<HiddenNeuron>();
    for(Axon axon : sourceAxons)
    {
      axon.setWeight(newWeight);
      HiddenNeuron axonSource = axon.getTarget();
      affectedNeurons.add(axonSource);
    }
    return affectedNeurons;
  }
}
