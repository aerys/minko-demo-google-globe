package render {
import aerys.minko.render.shader.ShaderAsset;
import aerys.minko.type.vertex.format.VertexComponent;
import flash.utils.ByteArray;
/**
* 
*/
public final class EarthShader extends ShaderAsset { 
private static const VERTEX_SHADER : ByteArray = ShaderAsset.decode('W8DIwMCwkEGCAQT4mYHEEwYIeMLIAAP8LIwIcThgBIozoIkDAA==')
private static const VERTEX_COMPONENTS : Vector.<VertexComponent> = Vector.<VertexComponent>([VertexComponent.XYZ,VertexComponent.UV,null,null,null,null,null,null]);
private static const FRAGMENT_SHADER : ByteArray = ShaderAsset.decode('W8DIwMCwkFGDAQT4mYDEExYGCGBlEBBgBtKMQHFGqDiQXgXSIYQkzgRR/gQkzoQQZ4BisDw3mnog'
+'HQqSh5kPFFuCrB7CZgcxl0D5S6D2ANkcIOZ/GB8B+JmR3AMGAA==')
public function EarthShader() {super(VERTEX_SHADER, FRAGMENT_SHADER, VERTEX_COMPONENTS);}
}
}