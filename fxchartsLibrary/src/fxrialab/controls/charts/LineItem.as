package fxrialab.controls.charts
{
	import spark.components.supportClasses.SkinnableComponent;
	
	public class LineItem extends SkinnableComponent
	{
		public function LineItem()
		{
			super();
			//this.setStyle("skinClass", LineItemSkin);
		}
		
		private var _data:Object;
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			if(_data == value) return;
			_data = value;
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			
			if(data.direction == "horizontal"){
				
				x = data.marginLeft + data.offSet + data.gapSum + data.barWidthSum + data.barWidth/2;
				if(data.minValue) {				
					y = data.height - data.value*data.heightChart/(data.maxValue+data.minValue) - data.marginBottom - data.minValue*data.heightChart/(data.maxValue+data.minValue);
				}else {
					y = data.height - data.value*data.heightChart/data.maxValue - data.marginBottom;
				}
			}else {
				if(data.minValue) {
					x = data.marginLeft + data.value*data.widthChart/(data.maxValue+data.minValue) + data.minValue*data.widthChart/(data.maxValue+data.minValue);
				}else {
					x = data.marginLeft + data.value*data.widthChart/data.maxValue;
				}
				y = data.height - (data.gapSum + data.barHeightSum + data.marginBottom + data.offSet + data.barHeight/2);
				
			}
			
		}
	}
}