package fxrialab.controls.charts.legend
{
	
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.core.UIComponent;
	
	import spark.components.supportClasses.SkinnableComponent;

	public class FxLegendLayout extends SkinnableComponent
	{
		public static const HORIZONTAL_BAR:String = 'horizontalBar';
		public static const VERTICAL_BAR:String = 'verticalBar';
		public static const LINE:String = 'line';
		public static const PIE:String = 'pie';
		public static const DOUGHNUT:String = 'doughnut';
		public static const HORIZONTAL_LAYOUT:String = "horizontalLayout";
		public static const VERTICAL_LAYOUT:String = "verticalLayout";
		
		private var _dataProvider:IList;
		private var redrawSkin:Boolean = false;
		private var _orientation:String;
	//	private var _fill:uint;
		
		private var _typeField:String = "type";
		private var _valueField:String = "value";
		private var _dataSeriesField:String = "data";
		private var _labelField:String = "label";
		private var _fillField:String = "fill";
		private var _strokeField:String = "stroke";
		private var _titleField:String = "title";
		
		private var fxLegendVer:Array = [];
		private var fxLegendHor:Array = [];
		
		[SkinPart]
		public var fxLegendHolder:UIComponent;
		
		public function FxLegendLayout()
		{
			super();
			this.setStyle('skinClass', FxLegendLayoutSkin);
			mouseChildren = true;
		}
		
		public function get orientation():String
		{
			return _orientation;
		}
		
		public function set orientation(value:String):void
		{
			_orientation = value;
			redrawSkin = true;
			invalidateProperties();
		}
		
		public function get dataProvider():IList
		{
			return _dataProvider;
		}
		
		public function set dataProvider(value:IList):void
		{
			if(value == _dataProvider) return;
			_dataProvider = value;
			redrawSkin = true;
			invalidateProperties();
		}
		
		override protected function commitProperties():void
		{
			// TODO Auto Generated method stub
			super.commitProperties();
			
			if(redrawSkin && skin && fxLegendHolder)
			{
				redrawSkin = false;
				
				fxLegendHolder.removeChildren();
				
				fxLegendVer = [];
				fxLegendHor = [];
				switch(orientation)
				{
					case HORIZONTAL_LAYOUT:
						for( var i:int=0; i < dataProvider.length; i++)
						{
							var dataSeries:Object 	= dataProvider.getItemAt(i);
							var getFill:String 		= (dataSeries[fillField] == null) ? "0xDC2400" : dataSeries[fillField];
							var fill:uint 			= (getFill.search('#') == 0) ? uint(getFill.replace('#', '0x')) : uint(getFill);
							var fxLegendHorizontal:FxLegendHorizontalLayout = new FxLegendHorizontalLayout;
							
							var skinClass:Class = getDefinitionByName("systemate.skins.charts.FxLegendHorizontalLayoutSkin") as Class;
						
							fxLegendHorizontal.setStyle("skinClass", skinClass);
							fxLegendHorizontal.data = dataProvider.getItemAt(i);
							
							fxLegendHorizontal.data.fill = fill;
							fxLegendHorizontal.dataProvider = dataProvider;
							fxLegendHolder.addChild(fxLegendHorizontal);
							fxLegendHor.push(fxLegendHorizontal);
						}
						break;
					case VERTICAL_LAYOUT:
						for( var j:int=0; j < dataProvider.length; j++)
						{
							var dataSeries:Object 	= dataProvider.getItemAt(j);
							var getFill:String 		= (dataSeries[fillField] == null) ? "0xDC2400" : dataSeries[fillField];
							var fill:uint 			= (getFill.search('#') == 0) ? uint(getFill.replace('#', '0x')) : uint(getFill);
							var fxLegendVertical:FxLegendVerticalLayout = new FxLegendVerticalLayout;
							
							var skinClass:Class = getDefinitionByName("systemate.skins.charts.FxLegendVerticalLayoutSkin") as Class;
							
							fxLegendVertical.setStyle("skinClass", skinClass);
							fxLegendVertical.data = dataProvider.getItemAt(j);
							
							fxLegendVertical.data.fill = fill;
							fxLegendVertical.dataProvider = dataProvider;
							fxLegendHolder.addChild(fxLegendVertical);
							fxLegendVer.push(fxLegendVertical);
						}
						break;
				}
				
				if(skin){
					skin.invalidateProperties();
					skin.invalidateDisplayList();
				}
			}
		}
		
		//private var fxLegend:DisplayObject;
		
		override protected function updateDisplayList(w:Number, h:Number):void
		{
			// TODO Auto Generated method stub
			super.updateDisplayList(w, h);
			
			if (orientation == VERTICAL_LAYOUT)
			{
				for( var i:int=0; i < dataProvider.length; i++)
				{
					var verticalLayout:FxLegendVerticalLayout = fxLegendVer[i] as FxLegendVerticalLayout;
					verticalLayout.data = dataProvider.getItemAt(i);
					verticalLayout.dataProvider = dataProvider;
				}
			}else {
				for( var j:int=0; j < dataProvider.length; j++)
				{
					var horizontalLayout:FxLegendHorizontalLayout = fxLegendHor[j] as FxLegendHorizontalLayout;
					horizontalLayout.data = dataProvider.getItemAt(j);
					horizontalLayout.dataProvider = dataProvider;
				}
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

		public function get titleField():String
		{
			return _titleField;
		}

		public function set titleField(value:String):void
		{
			_titleField = value;
		}

		/*public function get fill():uint
		{
			return _fill;
		}

		public function set fill(value:uint):void
		{
			_fill = value;
		}*/

		
	}
}