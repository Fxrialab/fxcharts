package fxrialab.controls.charts.legend
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	import fxrialab.controls.charts.supportClasses.UIComponent;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.IDataRenderer;
	import mx.core.IFactory;
	
	import spark.layouts.HorizontalLayout;
	import spark.layouts.VerticalLayout;
	
	[Style(name="fxLegendClass", inherit="no", type="Class")]
	public class FxLegend extends UIComponent
	{
		public static const HORIZONTAL_BAR:String = 'horizontalBar';
		public static const VERTICAL_BAR:String = 'verticalBar';
		public static const LINE:String = 'line';
		public static const PIE:String = 'pie';
		public static const DOUGHNUT:String = 'doughnut';
		public static const HORIZONTAL_LAYOUT:String = "horizontalLayout";
		public static const VERTICAL_LAYOUT:String = "verticalLayout";
		
		private var chartData:IList = new ArrayList();
		private var _typeField:String = "type";
		private var _valueField:String = "value";
		private var _dataSeriesField:String = "data";
		private var _labelField:String = "label";
		private var _fillField:String = "fill";
		private var _strokeField:String = "stroke";
		private var _titleField:String = "title";
		private var _gap:Number = 5;
		private var _checkFill:Boolean;
		private var redrawSkin:Boolean = false;
		private var fxLegend:DisplayObject;
		private var legend:Array = [];
		private var numberSeries:Array = [];
		private var numberDefaultItems:Number;
		
		public function FxLegend()
		{
			super();
			setStyle("fxLegendClass", FxLegendLayout);
		}
		
		private var _dataProvider:IList;
		private var _orientation:String = HORIZONTAL_LAYOUT;
		private var _itemRenderer:IFactory;
		
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
		protected var _dataSeries:Object;

		public function get dataSeries():Object
		{
			return _dataSeries;
		}

		public function set dataSeries(value:Object):void
		{
			_dataSeries = value;
			invalidateProperties();
		}

		
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
		
		private var dataItems:IList;
		
		public function set dataProvider(value:IList):void
		{
			if (value == _dataProvider) return;
			_dataProvider = value;
			redrawSkin = true;
			invalidateProperties();
			
			for(var j:int=0; j < dataProvider.length; j++){
				dataSeries = dataProvider.getItemAt(j);
				var chartTypes:String = String(dataSeries[typeField]);
				var dataItems:IList = new ArrayList(dataSeries[dataSeriesField] as Array);
				var chartFirstItem:Object = dataProvider.getItemAt(0);
				var firstType:String = String(chartFirstItem[typeField]);
				var firstDataItems:IList = new ArrayList(chartFirstItem[dataSeriesField] as Array);
				
				if (firstType == HORIZONTAL_BAR || firstType == VERTICAL_BAR || firstType == LINE)
					numberDefaultItems = dataItems.length;
				
				if (chartTypes == HORIZONTAL_BAR && numberDefaultItems == dataItems.length)
					numberSeries.push(HORIZONTAL_BAR);
				else if (chartTypes == VERTICAL_BAR && numberDefaultItems == dataItems.length)
					numberSeries.push(VERTICAL_BAR);
				
			}
		}		
		
		override protected function commitProperties():void 
		{
			super.commitProperties();
			
			if(redrawSkin && dataProvider)
			{
				for( var i:int=0; i < dataProvider.length; i++)
				{
					var dataSeries:Object 	= dataProvider.getItemAt(i);
					
					var chartTypes:String 	= String(dataSeries[typeField]);
					var dataItems:IList 	= new ArrayList(dataSeries[dataSeriesField] as Array);
					var chartFirstItem:Object 	= dataProvider.getItemAt(0);
					var firstType:String 	= String(chartFirstItem[typeField]);
					var firstDataItems:IList 	= new ArrayList(chartFirstItem[dataSeriesField] as Array);
			//		var getFill:String 		= (dataSeries[fillField] == null) ? "0xDC2400" : dataSeries[fillField];
			//		var fill:uint 			= (getFill.search('#') == 0) ? uint(getFill.replace('#', '0x')) : uint(getFill);
			//		var legendLabels 		= String(dataSeries[labelField]);
					
					var clazz:Class = getStyle('fxLegendClass') as Class;
					fxLegend = new clazz() as DisplayObject;
					
					if(dataProvider)
					{
						//@TODO: temp for display legend
						trace("number series: ", numberSeries.length);
						if (firstType == PIE)
							fxLegend['dataProvider'] = dataItems;
						else
							fxLegend['dataProvider'] = dataProvider;
					}
					fxLegend['orientation'] = orientation;
					
					//check chart type for display legends
					switch(firstType)
					{
						case HORIZONTAL_BAR:
							if(chartTypes == HORIZONTAL_BAR || chartTypes == LINE) {
								if(numberSeries.length > 1 && dataProvider.getItemAt(0).hasOwnProperty(labelField))
									addChild(fxLegend);
							}
							break;
						case VERTICAL_BAR:
							if (chartTypes == VERTICAL_BAR || chartTypes == LINE) {
								if(numberSeries.length > 1 && dataProvider.getItemAt(0).hasOwnProperty(labelField))
									addChild(fxLegend);
							}
							break;
						case LINE:
							if (chartTypes == VERTICAL_BAR || chartTypes == LINE || chartTypes == HORIZONTAL_BAR) {
								if(numberSeries.length > 1 && dataProvider.getItemAt(0).hasOwnProperty(labelField))
									addChild(fxLegend);
							}
							break;
						case PIE:
							if (chartTypes == PIE) {
								if(dataItems && dataItems.length > 1 && dataItems.getItemAt(0).hasOwnProperty(labelField))
									addChild(fxLegend);
							}
							break;
						case DOUGHNUT:
							if (chartTypes == DOUGHNUT) {
								if(dataItems && dataItems.length > 1 && dataItems.getItemAt(0).hasOwnProperty(labelField))
									addChild(fxLegend);
							}
							break;
					}
					
				}
			}
		}
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			// TODO Auto Generated method stub
			super.updateDisplayList(w, h);
			
			if(fxLegend)
			{
				fxLegend.width = w;
				fxLegend.height = h;
			}
		}
		
		private function handlerLegendMouseEvent(event:MouseEvent):void{
			switch(event.type) {
				case MouseEvent.MOUSE_DOWN:
					trace('mouse down');
					break;
				case MouseEvent.MOUSE_UP:
					trace('mouse up');
					//removeEventListener(MouseEvent.MOUSE_UP, handlerLegendMouseEvent);
					break;
			}
		}

		public function get typeField():String
		{
			return _typeField;
		}

		public function set typeField(value:String):void
		{
			_typeField = value;
		}

		public function get valueField():String
		{
			return _valueField;
		}

		public function set valueField(value:String):void
		{
			_valueField = value;
		}

		public function get dataSeriesField():String
		{
			return _dataSeriesField;
		}

		public function set dataSeriesField(value:String):void
		{
			_dataSeriesField = value;
		}

		public function get labelField():String
		{
			return _labelField;
		}

		public function set labelField(value:String):void
		{
			_labelField = value;
		}

		public function get fillField():String
		{
			return _fillField;
		}

		public function set fillField(value:String):void
		{
			_fillField = value;
		}

		public function get strokeField():String
		{
			return _strokeField;
		}

		public function set strokeField(value:String):void
		{
			_strokeField = value;
		}

		public function get itemRenderer():IFactory
		{
			return _itemRenderer;
		}

		public function set itemRenderer(value:IFactory):void
		{
			_itemRenderer = value;
			invalidateProperties();
		}

		public function get gap():Number
		{
			return _gap;
		}

		public function set gap(value:Number):void
		{
			_gap = value;
		}

		public function get titleField():String
		{
			return _titleField;
		}

		public function set titleField(value:String):void
		{
			_titleField = value;
		}

		public function get checkFill():Boolean
		{
			return _checkFill;
		}

		public function set checkFill(value:Boolean):void
		{
			_checkFill = value;
			
		}
		
		
		
		
	}
}