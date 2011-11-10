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
  protected double overallErrorContribution = -1;
  protected double outputValue = -1;
  
  public Neuron(String id)
  {
    this.id = id;
  }
  
  public final void receiveSignal(double signalStrength)
  {
    Network.debug("    " + this + " receiving signal " + signalStrength);
    Network.debug("      " + this + ": Old accumulated signal: " + accumulatedSignal);
    accumulatedSignal += signalStrength;
    Network.debug("      " + this + ": New accumulated signal: " + accumulatedSignal);
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
    return 2*(1.0 / (1 + Math.pow(Math.E, -1*accumulatedSignal))) - 1;
  }

  public abstract List<Neuron> fire();
  
  @Override
  public final String toString()
  {
    return id;
  }
  
  /**
   * Returns the error gradient with respect to the neuron's output (e.g. dE/dx).
   * It's conceptually the effect on the overall error of a small change in this neuron's output value.
   * This either comes recursively from lower layers or as a function of the output node's expected output.
   * @return
   */
  protected abstract double overallErrorCausedByOutput();

  /**
   * Returns the amount of error that the incoming value causes to the output
   * It's conceptually the effect on the neuron's output of a small change in the input.
   * e.g. dy_j/dx_i
   * @param a
   * @return
   */
  protected final double errorInOutputCausedByInput(Axon a)
  {
    return outputValue * (1 - outputValue) * a.getWeight();
  }
  protected final double errorInOutputCausedByWeight(Axon a)
  {
    return outputValue * (1 - outputValue) * a.getSource().getOutputValue();
  }
  
  protected final double overallErrorCausedByWeight(Axon a)
  {
    if(a.getTarget() != this)
    {
      Network.debug("EEK!!!" + "  We're on " + this + " and the axon connects " + a.getSource() + " and " + a.getTarget());
      throw new IllegalStateException();
      //return 0;
    }
    Network.debug(a.getSource() + "->" + a.getTarget() + ": " + overallErrorCausedByOutput());
    Network.debug(a.getSource() + "->" + a.getTarget() + ": " + errorInOutputCausedByWeight(a));
    return overallErrorCausedByOutput() * errorInOutputCausedByWeight(a);
  }
  
  public final List<Neuron> backPropogate()
  {
    // Reset signal accumulation
    accumulatedSignal = 0;
    
    Network.debug(this + " is backpropogating");
    List<Neuron> affectedNeurons = new ArrayList<Neuron>();
    for(Axon axon : sourceAxons)
    {
      Network.debug("Axon connects " + axon.getSource() + " and " + axon.getTarget());
      axon.adjustWeight();
      affectedNeurons.add(axon.getSource());
    }
    return affectedNeurons;
  }
}
