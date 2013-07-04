package fxrialab.controls.charts.legend
{
	import mx.collections.IList;
	
	import spark.components.supportClasses.SkinnableComponent;

	public class FxLegendHorizontalLayout extends SkinnableComponent
	{
		
		public function FxLegendHorizontalLayout()
		{
			super();
		//	this.setStyle("skinClass", FxLegendHorizontalLayoutSkin);
		}
		
		private var _data:Object;
		private var _dataProvider:IList;
		
		public function get data():Object
		{
			return _data;
		}
		
		public function set data(value:Object):void
		{
			if (_data == value) return;
			_data = value;
		}
		
		public function get dataProvider():IList
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:IList):void
		{
			if (value == _dataProvider) return;
			_dataProvider = value;
			
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			
		}
	}
}