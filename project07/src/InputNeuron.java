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
  public List<? extends Neuron> fire()
  {
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

  @Override
  public double getOutputErrorGradient()
  {
    // TODO Auto-generated method stub
    return 0;
  }

  @Override
  public List<? extends Neuron> backPropogate()
  {
    return new ArrayList<Neuron>();
  }
}
