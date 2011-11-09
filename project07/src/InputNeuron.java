import java.util.ArrayList;
import java.util.List;

public class InputNeuron extends Neuron
{
  public InputNeuron(String id, double initialValue)
  {
    super(id);
    this.outputValue = initialValue;
  }
  
  @Override
  public List<Neuron> fire()
  {
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

  @Override
  public double getOutputErrorGradient()
  {
    // never needed
    return 0;
  }
}
