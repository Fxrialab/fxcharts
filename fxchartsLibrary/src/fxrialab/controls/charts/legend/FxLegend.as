package fxrialab.controls.charts.legend
{
	import flash.text.TextField;
	
	import fxrialab.controls.charts.supportClasses.UIComponent;
	
	import mx.collections.IList;
	import mx.core.IDataRenderer;
	
	import spark.components.Group;
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalLayout;
	
	public class FxLegend extends UIComponent implements IDataRenderer
	{
		public static const HORIZONTAL_LAYOUT:String = "horizontalLayout";
		public static const VERTICAL_LAYOUT:String = "verticalLayout";
		
		public function FxLegend()
		{
			super();
		}
		
		private var _dataProvider:IList;
		private var _orientation:String = HORIZONTAL_LAYOUT;
		
		public function get orientation():String
		{
			return _orientation;
		}
		
		public function set orientation(value:String):void
		{
			_orientation = value;
			invalidateProperties();
		}
		
		protected var _data:Object;
		
		public function get data():Object
		{
			// TODO Auto Generated method stub
			return _data;
		}
		
		public function set data(value:Object):void
		{
			// TODO Auto Generated method stub
			_data = value;
			invalidateProperties();
		}
		
		public function get dataProvider():IList
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:IList):void
		{
			_dataProvider = value;
			invalidateProperties();
		}
		
		override protected function commitProperties():void 
		{
			super.commitProperties();

		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			// TODO Auto Generated method stub
			super.updateDisplayList(w, h);
		}
		
		
		
		
	}
}