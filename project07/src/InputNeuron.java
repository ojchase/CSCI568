import java.util.ArrayList;
import java.util.List;

public class InputNeuron extends Neuron
{

  public InputNeuron(String id, double initialValue)
  {
    super(id);
    final double EPSILON = 0.01;
    if(initialValue <= -1)
      initialValue = -1 + EPSILON;
    if(initialValue >= 1)
      initialValue = 1 - EPSILON;
    this.outputValue = initialValue;
  }
  
  @Override
  public List<Neuron> fire()
  {
    Network.debug(this + " is firing");
    List<Neuron> affectedNeurons = new ArrayList<Neuron>();
    for(Axon axon : targetAxons)
    {
      Network.debug("  " + this + ": Sending value down axon to " + axon.getTarget() + ": " + outputValue);
      axon.sendSignal(outputValue);
      Neuron axonTarget = axon.getTarget();
      if(axonTarget != null)
        affectedNeurons.add(axonTarget);
    }
    return affectedNeurons;
  }

  @Override
  public double getOutputErrorGradient()
  {
    // never needed
    return 0;
  }
}
