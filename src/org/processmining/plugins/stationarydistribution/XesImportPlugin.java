package org.processmining.plugins.stationarydistribution;

import java.io.InputStream;

import org.deckfour.xes.in.XesXmlParser;
import org.deckfour.xes.model.XLog;
import org.processmining.contexts.uitopia.annotations.UIImportPlugin;
import org.processmining.framework.abstractplugins.AbstractImportPlugin;
import org.processmining.framework.plugin.PluginContext;
import org.processmining.framework.plugin.annotations.Plugin;

@Plugin(name = "Import Xes", 
	parameterLabels = { "Filename" }, 
	returnLabels = { "Xes Log" }, 
	returnTypes = { XLog.class },
	userAccessible = true)
@UIImportPlugin(description = "Import xes", extensions = { ".xes", "xes" })
public class XesImportPlugin extends AbstractImportPlugin {
	@Override
	protected XLog importFromStream(final PluginContext context, 
			final InputStream input, 
			final String filename, 
			final long fileSizeInByes) {
		try {
			XesXmlParser parser = new XesXmlParser();
			return parser.parse(input).get(0);
		} catch (final Throwable _) {
			context.getFutureResult(0).setLabel("Import failed");
			return null;
		}
	}
}
