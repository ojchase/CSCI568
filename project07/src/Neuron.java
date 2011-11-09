import java.util.ArrayList;
import java.util.List;

public abstract class Neuron
{
  // The neuron shouldn't actually need to know who it's connected to.
  // It just sends signals up and down axons to whoever is listening.
  protected List<Axon> sourceAxons = new ArrayList<Axon>(); // These send signals to the neuron
  protected List<Axon> targetAxons = new ArrayList<Axon>(); // This neuron sends its signals via these axons
  protected double accumulatedSignal = 0; // Total signal received so far from its source neurons
  protected final String id;
  protected double outputErrorGradient = -1;
  protected double outputValue = -1;
  
  public Neuron(String id)
  {
    this.id = id;
  }
  
  public final void receiveSignal(double signalStrength)
  {
    accumulatedSignal += signalStrength;
  }

  protected final void addSourceAxon(Axon axon)
  {
    sourceAxons.add(axon);
  }

  protected final void addTargetAxon(Axon axon)
  {
    targetAxons.add(axon);
  }
  
  protected final double getOutputValue()
  {
    if(outputValue < 0)
      outputValue = calculateOutput(accumulatedSignal);
    return outputValue;
  }
  
  protected final double calculateOutput(double accumulatedSignal)
  {
    return 1.0 / (1 + Math.pow(Math.E, -1*accumulatedSignal));
  }

  public abstract List<Neuron> fire();
  
  @Override
  public final String toString()
  {
    return id;
  }
  
  /**
   * Returns the error gradient with respect to the neuron's output (e.g. dE/dx).
   * It's conceptually the effect on the overall error of a small change in this neuron's value.
   * @return
   */
  protected abstract double getOutputErrorGradient();

  /**
   * Returns the amount of error that the value of this neuron causes to a target neuron
   * It's conceptually the effect on the neuron's result of a small change in the input.
   * e.g. dy_j/dx_i
   * @param a
   * @return
   */
  protected final double errorCausedByInput(Axon a)
  {
    if(!(a.getSource() == this))
      return 0;
    Neuron source = a.getSource();
    double input = source.getOutputValue();
    return input * (1 - input) * a.getWeight();
  }

  public final List<Neuron> backPropogate()
  {
    List<Neuron> affectedNeurons = new ArrayList<Neuron>();
    for(Axon axon : sourceAxons)
    {
      double adjustment = errorCausedByInput(axon);
      axon.setWeight(axon.getWeight() + adjustment); // TODO calculate the right value
      Neuron axonSource = axon.getSource();
      affectedNeurons.add(axonSource);
    }
    return affectedNeurons;
  }
}
