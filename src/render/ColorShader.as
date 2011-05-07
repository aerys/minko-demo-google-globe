package render  {
import aerys.minko.render.shader.ShaderAsset;
import aerys.minko.type.vertex.format.VertexComponent;
import flash.utils.ByteArray;
/**
* 
*/
public final class ColorShader extends ShaderAsset { 
private static const VERTEX_SHADER : ByteArray = ShaderAsset.decode('W8DIwMCwkEGCAQT4mYHEEwYIeMLIAAP8LIwIcTAAAA==')
private static const VERTEX_COMPONENTS : Vector.<VertexComponent> = Vector.<VertexComponent>([VertexComponent.XYZ,VertexComponent.RGB,null,null,null,null,null,null]);
private static const FRAGMENT_SHADER : ByteArray = ShaderAsset.decode('W8DIwMCwEEQAAT8TkFjCwoAOOEDiDIwY4vzMQOIJE5IIAA==')
public function ColorShader() {super(VERTEX_SHADER, FRAGMENT_SHADER, VERTEX_COMPONENTS);}
}
}